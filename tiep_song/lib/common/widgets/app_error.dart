import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';
import 'app_button.dart';

class AppError extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppError({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColor.primary, size: 40),
            const SizedBox(height: 16),
            Text(
              message ?? 'Đã có lỗi xảy ra',
              style: AppTextStyle.body.copyWith(color: AppColor.textMuted),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton.outline(label: 'Thử lại', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
