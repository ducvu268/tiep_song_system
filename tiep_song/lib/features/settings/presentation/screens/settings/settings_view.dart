import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/bloc/base_state.dart';
import 'package:tiep_song/common/constants/app_text_style.dart';
import 'package:tiep_song/common/widgets/app_button.dart';
import 'package:tiep_song/common/widgets/app_scaffold.dart';
import 'package:tiep_song/features/settings/presentation/bloc/settings/settings_bloc.dart';

/// Màn Cài đặt cơ bản: tên + SĐT khẩn cấp, đính kèm vào mọi SOS gửi đi sau
/// đó — giúp đội cứu hộ/người nhận biết đang liên hệ với ai.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.toastSeq != current.toastSeq,
        listener: (context, state) {
          if (state.toastMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.toastMessage!)));
          }
        },
        builder: (context, state) {
          if (!_initialized && state.contact != null) {
            _nameController.text = state.contact!.name;
            _phoneController.text = state.contact!.phone;
            _initialized = true;
          }
          final isLoading = state.status == BaseStatus.loading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin liên hệ khẩn cấp',
                  style: AppTextStyle.h3,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Đính kèm vào mỗi SOS bạn gửi, giúp người nhận biết đang '
                  'liên hệ với ai.',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Họ tên'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                  ),
                ),
                const SizedBox(height: 24),
                AppButton.primary(
                  label: 'Lưu',
                  isLoading: isLoading,
                  onPressed: () => context.read<SettingsBloc>().add(
                        SettingsContactSaved(
                          name: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
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
