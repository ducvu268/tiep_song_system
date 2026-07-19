import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/features/sos/data/datasources/sos_local_datasource.dart';
import 'package:tiep_song/features/sos/data/datasources/sos_mesh_datasource.dart';
import 'package:tiep_song/features/sos/data/datasources/sos_remote_datasource.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';

/// Chiến lược: **local-first, mesh-always, server-when-possible**.
///
/// Khác với `ActivityRepositoryImpl` (network-first + cache fallback) trong
/// app gốc — ở đây network hiếm khi có sẵn nên phải đảo ngược thứ tự ưu
/// tiên hoàn toàn:
///   1. Ghi Hive TRƯỚC — đảm bảo không bao giờ mất dữ liệu người dùng vừa
///      nhập, kể cả app bị kill ngay sau đó.
///   2. Broadcast qua mesh — cố gắng hết sức, nhưng KHÔNG throw nếu thất
///      bại (ví dụ không có thiết bị Bridgefy nào gần đó). Request vẫn nằm
///      an toàn trong Hive, sẽ tự relay lại khi có thiết bị mới xuất hiện
///      trong tầm — xử lý ở tầng trên qua retry định kỳ, không phải ở đây.
///   3. Gọi server — CHỈ khi có mạng, và không chặn luồng chính (được
///      trigger riêng bởi `SyncPendingSosUseCase` qua connectivity stream).
@Injectable(as: SosRepository)
class SosRepositoryImpl implements SosRepository {
  final SosLocalDataSource _local;
  final SosMeshDataSource _mesh;
  final SosRemoteDataSource _remote;
  final _uuid = const Uuid();

  SosRepositoryImpl({
    required SosLocalDataSource localDataSource,
    required SosMeshDataSource meshDataSource,
    required SosRemoteDataSource remoteDataSource,
  }) : _local = localDataSource,
       _mesh = meshDataSource,
       _remote = remoteDataSource;

  @override
  Future<SosRequest> createSos({
    required double latitude,
    required double longitude,
    required ReliefNeedType needType,
    required int peopleCount,
    String? note,
    String? contactName,
    String? contactPhone,
  }) async {
    final entity = SosRequest(
      id: _uuid.v4(),
      latitude: latitude,
      longitude: longitude,
      needType: needType,
      peopleCount: peopleCount,
      note: note,
      createdAt: DateTime.now(),
      syncStatus: SosSyncStatus.pendingBroadcast,
      contactName: contactName,
      contactPhone: contactPhone,
    );
    var dto = SosRequestDto.fromDomain(entity);

    // Bước 1 — bắt buộc, không được phép thất bại thầm lặng.
    await _local.save(dto);

    // Bước 2 — cố gắng nhưng không chặn nếu lỗi.
    try {
      await _mesh.broadcast(dto);
      await _local.updateSyncStatus(dto.id, SosSyncStatus.relayedToMesh.name);
      dto = SosRequestDto.fromDomain(
        entity.copyWith(syncStatus: SosSyncStatus.relayedToMesh),
      );
    } catch (e) {
      AppLogger.warning(
        'Broadcast mesh thất bại cho SOS ${dto.id}, vẫn còn trong local: $e',
      );
    }

    return dto.toDomain();
  }

  @override
  Future<List<SosRequest>> getAllLocal() =>
      Future.value(_local.getAll().map((dto) => dto.toDomain()).toList());

  @override
  Future<List<SosRequest>> getPendingSync() => Future.value(
    _local.getPendingSync().map((dto) => dto.toDomain()).toList(),
  );

  @override
  Future<void> syncToServer(SosRequest request) async {
    final dto = SosRequestDto.fromDomain(request);
    await _remote.submit(dto);
    await _local.updateSyncStatus(dto.id, SosSyncStatus.syncedToServer.name);
  }

  @override
  Stream<SosRequest> get incomingFromMesh => _mesh.incoming.asyncMap((
    dto,
  ) async {
    // Request nhận từ hàng xóm qua mesh cũng phải lưu local — chính máy
    // này có thể là "cầu nối ra ngoài" duy nhất, cần giữ lại để sync sau.
    await _local.save(dto);
    return dto.toDomain();
  });
}
