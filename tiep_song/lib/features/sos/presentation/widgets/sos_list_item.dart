import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';
import 'package:tiep_song/common/widgets/app_status_pill.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/presentation/utils/sos_share_text.dart';

/// 1 dòng trong danh sách SOS — riêng của feature này, không dùng lại được
/// ở nơi khác nên không đưa lên common/widgets.
class SosListItem extends StatelessWidget {
  final SosRequest request;

  const SosListItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(request.needType.label, style: AppTextStyle.h3),
              ),
              AppStatusPill(
                syncStatus: request.syncStatus.name,
                label: request.syncStatus.label,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${request.peopleCount} người · ${DateFormat('HH:mm dd/MM').format(request.createdAt)}',
            style: AppTextStyle.body.copyWith(color: AppColor.textMuted),
          ),
          if (request.note != null && request.note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(request.note!, style: AppTextStyle.body),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Chia sẻ qua SMS/Zalo/email',
              onPressed: () => SharePlus.instance.share(
                ShareParams(text: buildSosShareText(request)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
