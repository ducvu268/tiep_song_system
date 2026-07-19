import 'package:flutter/material.dart';
import 'package:tiep_song/bootstrap.dart';
import 'package:tiep_song/common/router/app_router.dart';

Future<void> main() async {
  final initialLocation = await bootstrap();
  runApp(TiepSongApp(initialLocation: initialLocation));
}

class TiepSongApp extends StatelessWidget {
  final String initialLocation;

  const TiepSongApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tiếp Sóng',
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      routerConfig: buildAppRouter(initialLocation),
    );
  }
}
