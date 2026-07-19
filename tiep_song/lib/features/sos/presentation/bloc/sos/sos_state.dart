part of 'sos_bloc.dart';

class SosState extends BaseState {
  final SosRequest? lastSent;
  final int meshPeerCount;

  const SosState({
    super.status = BaseStatus.initial,
    super.errorMessage = '',
    super.toastMessage,
    super.toastSeq = 0,
    this.lastSent,
    this.meshPeerCount = 0,
  });

  SosState copyWith({
    BaseStatus? status,
    String? errorMessage,
    String? toastMessage,
    int? toastSeq,
    SosRequest? lastSent,
    int? meshPeerCount,
  }) => SosState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    toastMessage: toastMessage ?? this.toastMessage,
    toastSeq: toastSeq ?? this.toastSeq,
    lastSent: lastSent ?? this.lastSent,
    meshPeerCount: meshPeerCount ?? this.meshPeerCount,
  );

  @override
  List<Object?> get props => [...baseProps, lastSent, meshPeerCount];
}
