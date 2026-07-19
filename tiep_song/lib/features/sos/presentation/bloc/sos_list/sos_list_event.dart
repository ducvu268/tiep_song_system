part of 'sos_list_bloc.dart';

sealed class SosListEvent extends Equatable {
  const SosListEvent();

  @override
  List<Object?> get props => [];
}

/// Load lịch sử local + bắt đầu lắng nghe SOS mới nhận từ mesh.
class SosListStarted extends SosListEvent {
  const SosListStarted();
}

/// Nội bộ — bloc tự bắn khi [WatchIncomingSosUseCase] phát ra 1 request mới.
class SosListIncomingReceived extends SosListEvent {
  final SosRequest request;

  const SosListIncomingReceived(this.request);

  @override
  List<Object?> get props => [request];
}
