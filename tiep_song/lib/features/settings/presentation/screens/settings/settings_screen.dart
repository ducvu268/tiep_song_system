import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/features/settings/presentation/bloc/settings/settings_bloc.dart';

import 'settings_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(const SettingsStarted()),
      child: const SettingsView(),
    );
  }
}
