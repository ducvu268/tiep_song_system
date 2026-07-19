import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos/sos_bloc.dart';

import 'sos_view.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SosBloc>(),
      child: const SosView(),
    );
  }
}
