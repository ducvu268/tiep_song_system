import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';

/// Cho người dùng biết SOS có khả năng lan ra được hay không — dựa trên số
/// thiết bị Bridgefy đang kết nối trực tiếp (MeshService.connectedPeerCount).
/// Quan trọng lúc khẩn cấp: biết máy có "cô lập" hay không để quyết định có
/// cần di chuyển tới chỗ khác trước khi gửi hay không.
class MeshPeerBanner extends StatelessWidget {
  final int peerCount;

  const MeshPeerBanner({super.key, required this.peerCount});

  @override
  Widget build(BuildContext context) {
    final hasPeers = peerCount > 0;
    final color = hasPeers ? AppColor.success : AppColor.warning;
    final label = hasPeers
        ? 'Đang thấy $peerCount thiết bị gần đây'
        : 'Không có thiết bị nào gần đây — tín hiệu sẽ gửi khi có máy trong tầm';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            hasPeers ? Icons.bluetooth_connected : Icons.bluetooth_searching,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.subtitle.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
