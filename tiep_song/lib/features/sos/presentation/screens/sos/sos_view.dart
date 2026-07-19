import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiep_song/common/bloc/base_state.dart';
import 'package:tiep_song/common/router/app_router.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos/sos_bloc.dart';
import 'package:tiep_song/features/sos/presentation/utils/sos_share_text.dart';

/// Màn hình khẩn cấp: chủ đích tối giản, nút to, ít bước thao tác.
/// Người dùng có thể đang hoảng loạn/mất điện/tay run — không phải lúc
/// để test A/B UI đẹp.
class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  ReliefNeedType _selectedType = ReliefNeedType.rescue;
  int _peopleCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi tín hiệu SOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Các yêu cầu SOS gần đây',
            onPressed: () => context.push(AppRoute.sosList),
          ),
        ],
      ),
      body: BlocConsumer<SosBloc, SosState>(
        listener: (context, state) {
          if (state.status == BaseStatus.success) {
            final lastSent = state.lastSent;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Đã gửi. Tín hiệu đang được chuyển đi qua mạng lưới thiết bị gần bạn.',
                ),
                action: lastSent == null
                    ? null
                    : SnackBarAction(
                        label: 'CHIA SẺ',
                        onPressed: () => SharePlus.instance.share(
                          ShareParams(text: buildSosShareText(lastSent)),
                        ),
                      ),
              ),
            );
          } else if (state.status == BaseStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage.isEmpty
                      ? 'Có lỗi xảy ra'
                      : state.errorMessage,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == BaseStatus.loading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<ReliefNeedType>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(labelText: 'Bạn cần gì?'),
                  items: ReliefNeedType.values
                      .map(
                        (t) =>
                            DropdownMenuItem(value: t, child: Text(t.label)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Số người:'),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(
                        () => _peopleCount = (_peopleCount - 1).clamp(1, 99),
                      ),
                    ),
                    Text('$_peopleCount', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _peopleCount++),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    onPressed: isLoading
                        ? null
                        : () => context.read<SosBloc>().add(
                            SosSubmitted(
                              needType: _selectedType,
                              peopleCount: _peopleCount,
                            ),
                          ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'GỬI SOS',
                            style: TextStyle(fontSize: 22),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
