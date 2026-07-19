import 'package:go_router/go_router.dart';
import 'package:tiep_song/features/sos/presentation/screens/sos/sos_screen.dart';
import 'package:tiep_song/features/sos/presentation/screens/sos_list/sos_list_screen.dart';

abstract final class AppRoute {
  static const sos = '/';
  static const sosList = '/sos/list';
}

final appRouter = GoRouter(
  initialLocation: AppRoute.sos,
  routes: [
    GoRoute(path: AppRoute.sos, builder: (context, state) => const SosScreen()),
    GoRoute(
      path: AppRoute.sosList,
      builder: (context, state) => const SosListScreen(),
    ),
  ],
);
