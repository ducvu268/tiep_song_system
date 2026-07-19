import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos_list/sos_list_bloc.dart';

import 'sos_list_view.dart';

class SosListScreen extends StatelessWidget {
  const SosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SosListBloc>()..add(const SosListStarted()),
      child: const SosListView(),
    );
  }
}
