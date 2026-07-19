import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/errors/app_exception.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';

const String sosBoxName = 'sos_requests';

@injectable
class SosLocalDataSource {
  Box<SosRequestDto> get _box => Hive.box<SosRequestDto>(sosBoxName);

  Future<void> save(SosRequestDto dto) async {
    try {
      await _box.put(dto.id, dto);
    } catch (e) {
      throw CacheException('Không lưu được SOS vào local storage: $e');
    }
  }

  List<SosRequestDto> getAll() => _box.values.toList();

  List<SosRequestDto> getPendingSync() =>
      _box.values.where((e) => e.syncStatus != 'syncedToServer').toList();

  Future<void> updateSyncStatus(String id, String syncStatus) async {
    final existing = _box.get(id);
    if (existing == null) return;
    final updated = SosRequestDto(
      id: existing.id,
      latitude: existing.latitude,
      longitude: existing.longitude,
      needType: existing.needType,
      peopleCount: existing.peopleCount,
      note: existing.note,
      createdAt: existing.createdAt,
      syncStatus: syncStatus,
    );
    await _box.put(id, updated);
  }
}
