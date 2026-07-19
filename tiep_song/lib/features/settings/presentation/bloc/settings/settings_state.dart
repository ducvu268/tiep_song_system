part of 'settings_bloc.dart';

class SettingsState extends BaseState {
  final EmergencyContact? contact;

  const SettingsState({
    super.status = BaseStatus.initial,
    super.errorMessage = '',
    super.toastMessage,
    super.toastSeq = 0,
    this.contact,
  });

  SettingsState copyWith({
    BaseStatus? status,
    String? errorMessage,
    String? toastMessage,
    int? toastSeq,
    EmergencyContact? contact,
  }) => SettingsState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    toastMessage: toastMessage ?? this.toastMessage,
    toastSeq: toastSeq ?? this.toastSeq,
    contact: contact ?? this.contact,
  );

  @override
  List<Object?> get props => [...baseProps, contact];
}
