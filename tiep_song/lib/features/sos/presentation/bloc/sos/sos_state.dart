part of 'sos_bloc.dart';

class SosState extends BaseState {
  final SosRequest? lastSent;

  const SosState({
    super.status = BaseStatus.initial,
    super.errorMessage = '',
    super.toastMessage,
    super.toastSeq = 0,
    this.lastSent,
  });

  SosState copyWith({
    BaseStatus? status,
    String? errorMessage,
    String? toastMessage,
    int? toastSeq,
    SosRequest? lastSent,
  }) => SosState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    toastMessage: toastMessage ?? this.toastMessage,
    toastSeq: toastSeq ?? this.toastSeq,
    lastSent: lastSent ?? this.lastSent,
  );

  @override
  List<Object?> get props => [...baseProps, lastSent];
}
