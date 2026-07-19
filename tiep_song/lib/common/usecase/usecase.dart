/// Base class cho mọi Interactor/UseCase trong tầng Domain.
///
/// Quy ước:
/// - [Type] là kiểu dữ liệu trả về (thường là 1 Entity hoặc `void`).
/// - [Params] là object gom toàn bộ tham số đầu vào. Nếu UseCase không cần
///   tham số, dùng [NoParams].
/// - Interactor chỉ được gọi phương thức trên các `Repository` interface
///   (đã khai báo ở Domain) — KHÔNG được import trực tiếp bất kỳ thứ gì từ
///   tầng Data (ApiClient, HiveService, MeshService...).
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Cho Interactor trả về 1 Stream thay vì Future — dùng khi bloc cần lắng
/// nghe dữ liệu realtime (ví dụ SOS request nhận được từ mesh) mà vẫn phải
/// đi qua Repository interface, không được nghe thẳng từ tầng Data.
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams {
  const NoParams();
}
