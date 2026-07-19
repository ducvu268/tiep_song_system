import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/onboarding/domain/repository/onboarding_repository.dart';

@injectable
class HasSeenOnboardingUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository _repository;

  HasSeenOnboardingUseCase(this._repository);

  @override
  Future<bool> call(NoParams params) => _repository.hasSeenOnboarding();
}
