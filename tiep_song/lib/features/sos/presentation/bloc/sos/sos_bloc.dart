import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/bloc/base_bloc.dart';
import 'package:tiep_song/common/services/location_service.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/usecases/send_sos_usecase.dart';
import 'package:tiep_song/features/settings/domain/usecases/get_emergency_contact_usecase.dart';
import 'package:tiep_song/common/usecase/usecase.dart';

part 'sos_event.dart';
part 'sos_state.dart';

@injectable
class SosBloc extends BaseBloc<SosEvent, SosState> {
  final SendSosUseCase _sendSosUseCase;
  final LocationService _locationService;
  final GetEmergencyContactUseCase _getContactUseCase;

  SosBloc({
    required SendSosUseCase sendSosUseCase,
    required LocationService locationService,
    required GetEmergencyContactUseCase getEmergencyContactUseCase,
  }) : _sendSosUseCase = sendSosUseCase,
       _locationService = locationService,
       _getContactUseCase = getEmergencyContactUseCase,
       super(const SosState()) {
    on<SosSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(SosSubmitted event, Emitter<SosState> emit) async {
    emit(state.copyWith(status: BaseStatus.loading));

    await runSafely(emit, () async {
      final position = await _locationService.getCurrentPosition();
      final contact = await _getContactUseCase(const NoParams());

      final result = await _sendSosUseCase(
        SendSosParams(
          latitude: position.latitude,
          longitude: position.longitude,
          needType: event.needType,
          peopleCount: event.peopleCount,
          note: event.note,
          contactName: contact?.name,
          contactPhone: contact?.phone,
        ),
      );

      emit(state.copyWith(status: BaseStatus.success, lastSent: result));
    });
  }

  @override
  SosState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
