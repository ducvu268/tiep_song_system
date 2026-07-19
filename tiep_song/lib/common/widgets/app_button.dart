import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';

enum AppButtonSize { small, medium, large }

enum ButtonVariant { primary, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final bool isLoading;
  final AppButtonSize size;

  const AppButton._({
    required this.label,
    required this.variant,
    this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    super.key,
  });

  /// Nút mặc định — nền đỏ khẩn cấp. Dùng cho hành động chính của mỗi màn
  /// hình (gửi SOS, xác nhận).
  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    Widget? leadingIcon,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.medium,
    Key? key,
  }) => AppButton._(
    label: label,
    variant: ButtonVariant.primary,
    onPressed: onPressed,
    leadingIcon: leadingIcon,
    isLoading: isLoading,
    size: size,
    key: key,
  );

  factory AppButton.outline({
    required String label,
    VoidCallback? onPressed,
    Widget? leadingIcon,
    AppButtonSize size = AppButtonSize.medium,
    Key? key,
  }) => AppButton._(
    label: label,
    variant: ButtonVariant.outline,
    onPressed: onPressed,
    leadingIcon: leadingIcon,
    size: size,
    key: key,
  );

  factory AppButton.ghost({
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    Key? key,
  }) => AppButton._(
    label: label,
    variant: ButtonVariant.ghost,
    onPressed: onPressed,
    size: size,
    key: key,
  );

  bool get _disabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final (hPad, vPad, fontSize) = switch (size) {
      AppButtonSize.small => (18.0, 10.0, 13.0),
      AppButtonSize.medium => (24.0, 14.0, 15.0),
      // large: dùng cho nút SOS chính — vùng chạm rộng, dễ bấm khi tay run
      AppButtonSize.large => (32.0, 22.0, 20.0),
    };

    final textStyle = AppTextStyle.button.copyWith(fontSize: fontSize);

    final content = Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !isLoading,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 8),
              ],
              Text(label, style: textStyle),
            ],
          ),
        ),
        Visibility(
          visible: isLoading,
          child: SizedBox(
            width: fontSize + 2,
            height: fontSize + 2,
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ],
    );

    final button = switch (variant) {
      ButtonVariant.primary => Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: _disabled ? AppColor.surface2 : AppColor.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: DefaultTextStyle(
          style: textStyle.copyWith(
            color: _disabled ? AppColor.textFaint : AppColor.white,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: _disabled ? AppColor.textFaint : AppColor.white,
            ),
            child: content,
          ),
        ),
      ),
      ButtonVariant.outline => Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          border: Border.all(
            color: _disabled ? AppColor.textFaint : AppColor.primary,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: DefaultTextStyle(
          style: textStyle.copyWith(
            color: _disabled ? AppColor.textFaint : AppColor.primary,
          ),
          child: content,
        ),
      ),
      ButtonVariant.ghost => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: vPad),
        child: DefaultTextStyle(
          style: textStyle.copyWith(
            color: _disabled ? AppColor.textFaint : AppColor.primary,
          ),
          child: content,
        ),
      ),
    };

    return GestureDetector(
      onTap: _disabled ? null : (isLoading ? null : onPressed),
      child: button,
    );
  }
}
