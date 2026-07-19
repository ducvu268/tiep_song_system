import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/bloc/base_bloc.dart';
import 'package:tiep_song/common/services/location_service.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/usecases/send_sos_usecase.dart';

part 'sos_event.dart';
part 'sos_state.dart';

@injectable
class SosBloc extends BaseBloc<SosEvent, SosState> {
  final SendSosUseCase _sendSosUseCase;
  final LocationService _locationService;

  SosBloc({
    required SendSosUseCase sendSosUseCase,
    required LocationService locationService,
  }) : _sendSosUseCase = sendSosUseCase,
       _locationService = locationService,
       super(const SosState()) {
    on<SosSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(SosSubmitted event, Emitter<SosState> emit) async {
    emit(state.copyWith(status: BaseStatus.loading));

    await runSafely(emit, () async {
      final position = await _locationService.getCurrentPosition();

      final result = await _sendSosUseCase(
        SendSosParams(
          latitude: position.latitude,
          longitude: position.longitude,
          needType: event.needType,
          peopleCount: event.peopleCount,
          note: event.note,
        ),
      );

      emit(state.copyWith(status: BaseStatus.success, lastSent: result));
    });
  }

  @override
  SosState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
