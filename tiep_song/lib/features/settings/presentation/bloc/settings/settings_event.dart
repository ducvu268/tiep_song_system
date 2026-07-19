part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load thông tin liên hệ đã lưu (nếu có) khi vào màn Cài đặt.
class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsContactSaved extends SettingsEvent {
  final String name;
  final String phone;

  const SettingsContactSaved({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}
