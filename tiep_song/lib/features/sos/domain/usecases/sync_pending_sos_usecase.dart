import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';

/// Chạy mỗi khi thiết bị vừa bắt được sóng trở lại (trigger từ
/// ConnectivityService.onConnectivityChanged). Đẩy TẤT CẢ request đang
/// pending lên server — kể cả những cái relay được từ máy khác qua mesh,
/// vì thiết bị này có thể là "cầu nối ra ngoài" duy nhất trong khu vực.
@injectable
class SyncPendingSosUseCase implements UseCase<int, NoParams> {
  final SosRepository _repository;

  SyncPendingSosUseCase(this._repository);

  @override
  Future<int> call(NoParams params) async {
    final pending = await _repository.getPendingSync();
    var successCount = 0;

    // Tuần tự, không Future.wait song song — tránh làm sập backend bằng
    // 1 burst lớn khi hàng trăm request dồn lại sau nhiều giờ mất mạng.
    for (final request in pending) {
      try {
        await _repository.syncToServer(request);
        successCount++;
      } catch (e) {
        // 1 request lỗi không được chặn các request còn lại.
        AppLogger.warning('Sync thất bại cho SOS ${request.id}: $e');
      }
    }
    return successCount;
  }
}
