import 'package:flutter/material.dart';
import 'package:tiep_song/bootstrap.dart';
import 'package:tiep_song/common/router/app_router.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const TiepSongApp());
}

class TiepSongApp extends StatelessWidget {
  const TiepSongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tiếp Sóng',
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
