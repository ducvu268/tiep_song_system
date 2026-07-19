import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/settings/domain/models/emergency_contact.dart';
import 'package:tiep_song/features/settings/domain/repository/settings_repository.dart';

@injectable
class GetEmergencyContactUseCase
    implements UseCase<EmergencyContact?, NoParams> {
  final SettingsRepository _repository;

  GetEmergencyContactUseCase(this._repository);

  @override
  Future<EmergencyContact?> call(NoParams params) => _repository.getContact();
}
