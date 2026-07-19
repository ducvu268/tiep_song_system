import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';

abstract class SosRepository {
  /// Tạo 1 SOS request: LUÔN lưu local trước (không bao giờ mất dữ liệu dù
  /// app bị kill ngay sau đó), sau đó cố gắng broadcast qua mesh.
  /// Không throw nếu mesh thất bại — dữ liệu vẫn an toàn trong local storage
  /// và sẽ được thử lại bởi `SyncSosUseCase`.
  Future<SosRequest> createSos({
    required double latitude,
    required double longitude,
    required ReliefNeedType needType,
    required int peopleCount,
    String? note,
    String? contactName,
    String? contactPhone,
  });

  /// Toàn bộ SOS request đang lưu local — của chính máy này và những cái
  /// nhận relay được từ mesh (để hiện lên UI dạng "các yêu cầu gần đây").
  Future<List<SosRequest>> getAllLocal();

  /// Các request chưa `syncedToServer` — dùng khi có mạng để đẩy hàng loạt lên.
  Future<List<SosRequest>> getPendingSync();

  /// Gửi 1 request lên backend Spring Boot, đánh dấu synced nếu thành công.
  Future<void> syncToServer(SosRequest request);

  /// Lắng nghe SOS request nhận được từ mesh (relay từ thiết bị khác) —
  /// để UI hiện realtime khi có ai đó gần mình gửi tín hiệu.
  Stream<SosRequest> get incomingFromMesh;
}
