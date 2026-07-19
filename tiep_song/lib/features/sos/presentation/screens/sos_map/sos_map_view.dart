import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:tiep_song/common/constants/app_color.dart';
import 'package:tiep_song/common/router/app_router.dart';
import 'package:tiep_song/common/widgets/app_error.dart';
import 'package:tiep_song/common/widgets/app_loading.dart';
import 'package:tiep_song/common/widgets/app_scaffold.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos_list/sos_list_bloc.dart';
import 'package:tiep_song/features/sos/presentation/widgets/sos_list_item.dart';

/// Tâm bản đồ mặc định khi chưa có SOS nào — trung tâm địa lý Việt Nam.
const _defaultCenter = LatLng(16.0, 108.0);

class SosMapView extends StatelessWidget {
  const SosMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Bản đồ SOS gần đây'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Xem dạng danh sách',
            onPressed: () => context.push(AppRoute.sosList),
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

          final center = state.items.isEmpty
              ? _defaultCenter
              : LatLng(
                  state.items.first.latitude,
                  state.items.first.longitude,
                );

          return FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: state.items.isEmpty ? 5 : 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tiepsong.tiep_song',
              ),
              MarkerLayer(
                markers: state.items
                    .map(
                      (request) => Marker(
                        point: LatLng(request.latitude, request.longitude),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => _showDetail(context, request),
                          child: Icon(
                            Icons.location_on,
                            color: AppColor.forSyncStatus(
                              request.syncStatus.name,
                            ),
                            size: 40,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, SosRequest request) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: SosListItem(request: request),
      ),
    );
  }
}
