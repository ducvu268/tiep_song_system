import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/bloc/base_bloc.dart';
import 'package:tiep_song/common/config/app_config.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/common/services/location_service.dart';
import 'package:tiep_song/common/services/mesh_service.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/onboarding/domain/usecases/mark_onboarding_seen_usecase.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

/// Màn onboarding đứng trước MỌI thứ (kể cả trước SosScreen) đúng 1 lần —
/// mục đích: giải thích vì sao cần Location/Bluetooth TRƯỚC khi OS bật
/// popup xin quyền, thay vì để popup bật bất ngờ không rõ lý do. Vì vậy
/// việc start MeshService (trigger popup Bluetooth) bị dời từ
/// `bootstrap.dart` sang đây — chỉ chạy SAU khi user bấm "Tiếp tục".
@injectable
class OnboardingBloc extends BaseBloc<OnboardingEvent, OnboardingState> {
  final MarkOnboardingSeenUseCase _markSeen;
  final LocationService _locationService;
  final MeshService _meshService;
  final AppConfig _appConfig;

  OnboardingBloc({
    required MarkOnboardingSeenUseCase markOnboardingSeenUseCase,
    required LocationService locationService,
    required MeshService meshService,
    required AppConfig appConfig,
  })  : _markSeen = markOnboardingSeenUseCase,
        _locationService = locationService,
        _meshService = meshService,
        _appConfig = appConfig,
        super(const OnboardingState()) {
    on<OnboardingContinuePressed>(_onContinuePressed);
  }

  Future<void> _onContinuePressed(
    OnboardingContinuePressed event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading));

    await runSafely(emit, () async {
      // Mồi quyền Location ngay — lỗi (từ chối/tắt GPS) không chặn tiếp
      // tục vào app, chỉ là cơ hội để user thấy popup lúc đã hiểu lý do.
      try {
        await _locationService.getCurrentPosition();
      } catch (e) {
        AppLogger.warning('Onboarding: mồi quyền Location thất bại: $e');
      }

      try {
        await _meshService.start(apiKey: _appConfig.bridgefyApiKey);
      } catch (e) {
        AppLogger.warning('Onboarding: mesh service không khởi động được: $e');
      }

      await _markSeen(const NoParams());
      emit(state.copyWith(status: BaseStatus.success));
    });
  }

  @override
  OnboardingState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
