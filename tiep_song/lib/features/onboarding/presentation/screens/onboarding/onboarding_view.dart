import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiep_song/common/bloc/base_state.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';
import 'package:tiep_song/common/router/app_router.dart';
import 'package:tiep_song/common/widgets/app_button.dart';
import 'package:tiep_song/common/widgets/app_scaffold.dart';
import 'package:tiep_song/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';

/// Chỉ hiện đúng 1 lần (lúc chưa `hasSeenOnboarding`) — giải thích TRƯỚC
/// khi OS bật popup xin quyền Location/Bluetooth, thay vì để popup bật bất
/// ngờ không rõ lý do ngay khi mở app lần đầu.
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.status == BaseStatus.success) {
            context.go(AppRoute.sos);
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final isLoading = state.status == BaseStatus.loading;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sos_rounded,
                    size: 72,
                    color: AppColor.primary,
                  ),
                  const SizedBox(height: 24),
                  Text('Tiếp Sóng', style: AppTextStyle.display),
                  const SizedBox(height: 16),
                  Text(
                    'Ứng dụng gửi tín hiệu SOS hoạt động ngay cả khi không '
                    'còn sóng điện thoại hay internet.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.body.copyWith(
                      color: AppColor.textMuted,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _PermissionReason(
                    icon: Icons.location_on_outlined,
                    text: 'Vị trí — để đính kèm toạ độ vào tín hiệu SOS, giúp '
                        'đội cứu hộ tìm đúng nơi bạn cần giúp đỡ.',
                  ),
                  const SizedBox(height: 16),
                  _PermissionReason(
                    icon: Icons.bluetooth,
                    text: 'Bluetooth — để chuyển tiếp tín hiệu SOS qua các '
                        'thiết bị gần đó khi không có mạng.',
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.primary(
                      label: 'Tiếp tục',
                      size: AppButtonSize.large,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => context.read<OnboardingBloc>().add(
                                const OnboardingContinuePressed(),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PermissionReason extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PermissionReason({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.mesh),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyle.body)),
      ],
    );
  }
}
