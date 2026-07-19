abstract class OnboardingRepository {
  /// `true` nếu người dùng đã từng xem qua màn giải thích quyền
  /// Location/Bluetooth và bấm "Tiếp tục".
  Future<bool> hasSeenOnboarding();

  Future<void> markSeen();
}
