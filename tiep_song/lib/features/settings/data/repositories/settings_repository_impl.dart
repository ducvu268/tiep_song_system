import 'package:injectable/injectable.dart';
import 'package:tiep_song/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tiep_song/features/settings/domain/models/emergency_contact.dart';
import 'package:tiep_song/features/settings/domain/repository/settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;

  SettingsRepositoryImpl(this._local);

  @override
  Future<EmergencyContact?> getContact() async {
    final name = _local.contactName;
    final phone = _local.contactPhone;
    if (name == null || phone == null) return null;
    return EmergencyContact(name: name, phone: phone);
  }

  @override
  Future<void> saveContact(EmergencyContact contact) =>
      _local.saveContact(name: contact.name, phone: contact.phone);
}
