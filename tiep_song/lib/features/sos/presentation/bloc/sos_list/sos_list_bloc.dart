import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/bloc/base_bloc.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/usecases/get_sos_history_usecase.dart';
import 'package:tiep_song/features/sos/domain/usecases/watch_incoming_sos_usecase.dart';

part 'sos_list_event.dart';
part 'sos_list_state.dart';

@injectable
class SosListBloc extends BaseBloc<SosListEvent, SosListState> {
  final GetSosHistoryUseCase _getHistory;
  final WatchIncomingSosUseCase _watchIncoming;

  StreamSubscription<SosRequest>? _incomingSubscription;

  SosListBloc({
    required GetSosHistoryUseCase getSosHistoryUseCase,
    required WatchIncomingSosUseCase watchIncomingSosUseCase,
  }) : _getHistory = getSosHistoryUseCase,
       _watchIncoming = watchIncomingSosUseCase,
       super(const SosListState()) {
    on<SosListStarted>(_onStarted);
    on<SosListIncomingReceived>(_onIncomingReceived);
  }

  Future<void> _onStarted(
    SosListStarted event,
    Emitter<SosListState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading));

    await runSafely(emit, () async {
      final items = await _getHistory(const NoParams());
      emit(state.copyWith(status: BaseStatus.success, items: _sorted(items)));
    });

    await _incomingSubscription?.cancel();
    _incomingSubscription = _watchIncoming(
      const NoParams(),
    ).listen((request) => add(SosListIncomingReceived(request)));
  }

  void _onIncomingReceived(
    SosListIncomingReceived event,
    Emitter<SosListState> emit,
  ) {
    final items = [
      event.request,
      ...state.items.where((r) => r.id != event.request.id),
    ];
    emit(state.copyWith(items: _sorted(items)));
  }

  List<SosRequest> _sorted(List<SosRequest> items) =>
      items..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<void> close() {
    _incomingSubscription?.cancel();
    return super.close();
  }

  @override
  SosListState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
