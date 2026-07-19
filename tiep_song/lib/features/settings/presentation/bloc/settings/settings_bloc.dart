import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/bloc/base_bloc.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/settings/domain/models/emergency_contact.dart';
import 'package:tiep_song/features/settings/domain/usecases/get_emergency_contact_usecase.dart';
import 'package:tiep_song/features/settings/domain/usecases/save_emergency_contact_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends BaseBloc<SettingsEvent, SettingsState> {
  final GetEmergencyContactUseCase _getContact;
  final SaveEmergencyContactUseCase _saveContact;

  SettingsBloc({
    required GetEmergencyContactUseCase getEmergencyContactUseCase,
    required SaveEmergencyContactUseCase saveEmergencyContactUseCase,
  }) : _getContact = getEmergencyContactUseCase,
       _saveContact = saveEmergencyContactUseCase,
       super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsContactSaved>(_onContactSaved);
  }

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading));
    await runSafely(emit, () async {
      final contact = await _getContact(const NoParams());
      emit(state.copyWith(status: BaseStatus.success, contact: contact));
    });
  }

  Future<void> _onContactSaved(
    SettingsContactSaved event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading));
    await runSafely(emit, () async {
      final contact = EmergencyContact(name: event.name, phone: event.phone);
      await _saveContact(contact);
      emit(
        state.copyWith(
          status: BaseStatus.success,
          contact: contact,
          toastMessage: 'Đã lưu thông tin liên hệ khẩn cấp',
          toastSeq: state.toastSeq + 1,
        ),
      );
    });
  }

  @override
  SettingsState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
