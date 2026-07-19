import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/settings/domain/models/emergency_contact.dart';
import 'package:tiep_song/features/settings/domain/repository/settings_repository.dart';

@injectable
class SaveEmergencyContactUseCase implements UseCase<void, EmergencyContact> {
  final SettingsRepository _repository;

  SaveEmergencyContactUseCase(this._repository);

  @override
  Future<void> call(EmergencyContact params) =>
      _repository.saveContact(params);
}
