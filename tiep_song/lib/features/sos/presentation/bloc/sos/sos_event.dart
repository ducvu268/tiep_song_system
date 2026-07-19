part of 'sos_bloc.dart';

sealed class SosEvent extends Equatable {
  const SosEvent();

  @override
  List<Object?> get props => [];
}

class SosSubmitted extends SosEvent {
  final ReliefNeedType needType;
  final int peopleCount;
  final String? note;

  const SosSubmitted({
    required this.needType,
    required this.peopleCount,
    this.note,
  });

  @override
  List<Object?> get props => [needType, peopleCount, note];
}

/// Nội bộ — bloc tự bắn khi MeshService báo số thiết bị kết nối trực tiếp
/// thay đổi (dùng cho banner "đang thấy X thiết bị gần đây" ở SosView).
class SosMeshPeerCountChanged extends SosEvent {
  final int count;

  const SosMeshPeerCountChanged(this.count);

  @override
  List<Object?> get props => [count];
}
