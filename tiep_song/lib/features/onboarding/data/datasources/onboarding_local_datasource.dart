import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/features/settings/data/datasources/settings_local_datasource.dart'
    show settingsBoxName;

const _keyOnboardingCompleted = 'onboarding_completed';

/// Dùng chung Hive box với Settings — cũng chỉ là 1 giá trị bool đơn giản,
/// không đáng mở riêng 1 box nữa.
@injectable
class OnboardingLocalDataSource {
  Box get _box => Hive.box(settingsBoxName);

  bool get hasSeenOnboarding =>
      _box.get(_keyOnboardingCompleted, defaultValue: false) as bool;

  Future<void> markSeen() => _box.put(_keyOnboardingCompleted, true);
}
