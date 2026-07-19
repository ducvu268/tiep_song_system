import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/features/sos/presentation/bloc/sos_list/sos_list_bloc.dart';

import 'sos_map_view.dart';

/// Dùng chung [SosListBloc] với màn danh sách — cùng 1 nguồn dữ liệu
/// (local + nhận từ mesh), chỉ khác cách trình bày (list chữ vs bản đồ).
class SosMapScreen extends StatelessWidget {
  const SosMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SosListBloc>()..add(const SosListStarted()),
      child: const SosMapView(),
    );
  }
}
