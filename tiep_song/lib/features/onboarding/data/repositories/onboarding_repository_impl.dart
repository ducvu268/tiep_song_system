import 'package:injectable/injectable.dart';
import 'package:tiep_song/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tiep_song/features/onboarding/domain/repository/onboarding_repository.dart';

@Injectable(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _local;

  OnboardingRepositoryImpl(this._local);

  @override
  Future<bool> hasSeenOnboarding() async => _local.hasSeenOnboarding;

  @override
  Future<void> markSeen() => _local.markSeen();
}
