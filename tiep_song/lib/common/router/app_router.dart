import 'package:go_router/go_router.dart';
import 'package:tiep_song/features/onboarding/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:tiep_song/features/settings/presentation/screens/settings/settings_screen.dart';
import 'package:tiep_song/features/sos/presentation/screens/sos/sos_screen.dart';
import 'package:tiep_song/features/sos/presentation/screens/sos_list/sos_list_screen.dart';
import 'package:tiep_song/features/sos/presentation/screens/sos_map/sos_map_screen.dart';

abstract final class AppRoute {
  static const onboarding = '/onboarding';
  static const sos = '/';
  static const sosList = '/sos/list';
  static const sosMap = '/sos/map';
  static const settings = '/settings';
}

GoRouter buildAppRouter(String initialLocation) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoute.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
            path: AppRoute.sos, builder: (context, state) => const SosScreen()),
        GoRoute(
          path: AppRoute.sosList,
          builder: (context, state) => const SosListScreen(),
        ),
        GoRoute(
          path: AppRoute.sosMap,
          builder: (context, state) => const SosMapScreen(),
        ),
        GoRoute(
          path: AppRoute.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
