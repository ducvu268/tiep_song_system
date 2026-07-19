/// Base cho mọi lỗi có kiểm soát trong app. Bloc chỉ bắt [AppException],
/// còn lỗi lạ (chưa lường trước) được bọc lại thành [UnknownException].
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Không có sóng/internet VÀ mesh network cũng không tìm thấy peer nào gần đó.
/// Đây là lỗi "bình thường" trong app này — không phải sự cố, mà là điều kiện
/// vận hành thực tế cần UI xử lý gracefully (vẫn lưu local, báo cho user biết).
class NoConnectivityException extends AppException {
  const NoConnectivityException()
    : super('Không có mạng và không tìm thấy thiết bị nào gần đó để relay.');
}

/// Lỗi khi gọi API backend (Spring Boot) lúc sync.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

/// Lỗi khi thao tác với Hive (đọc/ghi local storage).
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Lỗi liên quan tới Bridgefy SDK (BLE mesh) — ví dụ Bluetooth bị tắt,
/// thiếu quyền, hoặc SDK chưa start.
class MeshException extends AppException {
  const MeshException(super.message);
}

/// Lỗi lấy vị trí GPS (bị từ chối quyền, GPS tắt...).
class LocationException extends AppException {
  const LocationException(super.message);
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}
