import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/common/services/connectivity_service.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';
import 'package:tiep_song/features/sos/domain/usecases/sync_pending_sos_usecase.dart';

/// Chạy 1 lần lúc app khởi động (gọi từ `bootstrap.dart`), sống suốt vòng
/// đời app. Gánh 2 việc nền không gắn với 1 màn hình cụ thể nào:
///
/// 1. Giữ 1 subscriber luôn lắng nghe `SosRepository.incomingFromMesh`.
///    Nếu không ai subscribe, gói tin SOS relay từ thiết bị khác tới lúc
///    không có màn hình danh sách nào đang mở sẽ bị rớt — stream bên dưới
///    là broadcast, không buffer cho subscriber tới trễ.
/// 2. Tự động gọi [SyncPendingSosUseCase] mỗi khi mạng vừa có trở lại,
///    không cần user tự bấm nút đồng bộ.
@lazySingleton
class SosBackgroundSync {
  final SosRepository _repository;
  final ConnectivityService _connectivity;
  final SyncPendingSosUseCase _syncPendingSos;

  StreamSubscription<void>? _meshSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  SosBackgroundSync({
    required SosRepository repository,
    required ConnectivityService connectivityService,
    required SyncPendingSosUseCase syncPendingSosUseCase,
  }) : _repository = repository,
       _connectivity = connectivityService,
       _syncPendingSos = syncPendingSosUseCase;

  void start() {
    if (_meshSubscription != null) return;

    _meshSubscription = _repository.incomingFromMesh.listen(
      (request) => AppLogger.info(
        'SosBackgroundSync: nhận SOS ${request.id} từ mesh, đã lưu local',
      ),
    );

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .where((isOnline) => isOnline)
        .listen((_) => _runSync());

    _connectivity.isOnline.then((isOnline) {
      if (isOnline) _runSync();
    });
  }

  Future<void> _runSync() async {
    try {
      final count = await _syncPendingSos(const NoParams());
      if (count > 0) {
        AppLogger.info('SosBackgroundSync: đã đồng bộ $count SOS lên server');
      }
    } catch (e) {
      AppLogger.warning('SosBackgroundSync: đồng bộ thất bại: $e');
    }
  }

  Future<void> dispose() async {
    await _meshSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    _meshSubscription = null;
    _connectivitySubscription = null;
  }
}
