import 'package:tiep_song/features/settings/domain/models/emergency_contact.dart';

abstract class SettingsRepository {
  /// `null` nếu người dùng chưa từng nhập thông tin liên hệ.
  Future<EmergencyContact?> getContact();

  Future<void> saveContact(EmergencyContact contact);
}
