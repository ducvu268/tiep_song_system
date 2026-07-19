import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';

import 'onboarding_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingBloc>(),
      child: const OnboardingView(),
    );
  }
}
