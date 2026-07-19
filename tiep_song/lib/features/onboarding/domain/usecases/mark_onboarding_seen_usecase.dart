import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/onboarding/domain/repository/onboarding_repository.dart';

@injectable
class MarkOnboardingSeenUseCase implements UseCase<void, NoParams> {
  final OnboardingRepository _repository;

  MarkOnboardingSeenUseCase(this._repository);

  @override
  Future<void> call(NoParams params) => _repository.markSeen();
}
