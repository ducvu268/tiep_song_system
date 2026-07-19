import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiep_song/common/router/app_router.dart';
import 'package:tiep_song/common/widgets/app_error.dart';
import 'package:tiep_song/common/widgets/app_loading.dart';
import 'package:tiep_song/common/widgets/app_scaffold.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos_list/sos_list_bloc.dart';
import 'package:tiep_song/features/sos/presentation/widgets/sos_list_item.dart';

class SosListView extends StatelessWidget {
  const SosListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Các yêu cầu SOS gần đây'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Xem dạng bản đồ',
            onPressed: () => context.push(AppRoute.sosMap),
          ),
        ],
      ),
      body: BlocBuilder<SosListBloc, SosListState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.isFailure && state.items.isEmpty) {
            return AppError(
              message: state.errorMessage,
              onRetry: () =>
                  context.read<SosListBloc>().add(const SosListStarted()),
            );
          }
          if (state.items.isEmpty) {
            return const AppError(message: 'Chưa có yêu cầu SOS nào.');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                SosListItem(request: state.items[index]),
          );
        },
      ),
    );
  }
}
