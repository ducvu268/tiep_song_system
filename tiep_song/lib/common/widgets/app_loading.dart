import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';

class AppLoading extends StatelessWidget {
  final double size;

  const AppLoading({super.key, this.size = 24});

  const factory AppLoading.overlay({Key? key}) = _OverlayLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
        ),
      ),
    );
  }
}

class _OverlayLoading extends AppLoading {
  const _OverlayLoading({super.key}) : super(size: 36);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.shadow,
      child: super.build(context),
    );
  }
}
