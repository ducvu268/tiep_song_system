import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';

/// Pill nhỏ hiển thị trạng thái đồng bộ của 1 SOS request trong danh sách —
/// màu theo [AppColor.forSyncStatus] để phân biệt nhanh
/// pending/mesh/synced chỉ bằng màu, không cần đọc chữ.
class AppStatusPill extends StatelessWidget {
  final String syncStatus;
  final String label;

  const AppStatusPill({
    super.key,
    required this.syncStatus,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColor.forSyncStatus(syncStatus);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: AppTextStyle.subtitle.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
