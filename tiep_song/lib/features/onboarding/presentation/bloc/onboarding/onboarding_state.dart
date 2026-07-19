part of 'onboarding_bloc.dart';

class OnboardingState extends BaseState {
  const OnboardingState({
    super.status = BaseStatus.initial,
    super.errorMessage = '',
    super.toastMessage,
    super.toastSeq = 0,
  });

  OnboardingState copyWith({
    BaseStatus? status,
    String? errorMessage,
    String? toastMessage,
    int? toastSeq,
  }) =>
      OnboardingState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        toastMessage: toastMessage ?? this.toastMessage,
        toastSeq: toastSeq ?? this.toastSeq,
      );

  @override
  List<Object?> get props => baseProps;
}
