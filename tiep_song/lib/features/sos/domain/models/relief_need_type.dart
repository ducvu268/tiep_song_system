/// Loại nhu cầu cứu trợ — khớp với enum phía backend Spring Boot
/// (xem `ReliefNeedType.java`) để tránh lệch mapping khi serialize.
enum ReliefNeedType {
  rescue, // cứu hộ khẩn cấp, mắc kẹt/nguy hiểm tính mạng
  food,
  water,
  medical,
  shelter;

  String get label => switch (this) {
    ReliefNeedType.rescue => 'Cứu hộ khẩn cấp',
    ReliefNeedType.food => 'Lương thực',
    ReliefNeedType.water => 'Nước uống',
    ReliefNeedType.medical => 'Y tế / thuốc men',
    ReliefNeedType.shelter => 'Chỗ trú ẩn',
  };
}

/// Trạng thái đồng bộ của 1 SOS request — vòng đời dữ liệu trong app.
enum SosSyncStatus {
  /// Vừa tạo, mới lưu local, chưa gửi đi đâu cả.
  pendingBroadcast,

  /// Đã broadcast qua mesh, đang chờ 1 thiết bị nào đó có sóng relay tiếp.
  relayedToMesh,

  /// Đã đồng bộ thành công lên backend (server đã xác nhận nhận được).
  syncedToServer;

  String get label => switch (this) {
    SosSyncStatus.pendingBroadcast => 'Đang chờ gửi',
    SosSyncStatus.relayedToMesh => 'Đã qua mesh',
    SosSyncStatus.syncedToServer => 'Đã đồng bộ',
  };
}
