import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiep_song/common/config/app_config.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/common/router/app_router.dart';
import 'package:tiep_song/common/services/mesh_service.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/data/datasources/sos_local_datasource.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';
import 'package:tiep_song/features/sos/domain/services/sos_background_sync.dart';
import 'package:tiep_song/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tiep_song/features/onboarding/domain/usecases/has_seen_onboarding_usecase.dart';

/// Thứ tự khởi tạo có chủ đích:
///   1. Hive trước tiên — nếu bước sau lỗi, local storage vẫn sẵn sàng
///      nhận dữ liệu (không có gì tệ hơn app crash lúc khởi động mà
///      không lưu được SOS).
///   2. DI container.
///   3. Mesh service start — CHỈ khi đã qua onboarding (đã hiểu vì sao cần
///      quyền Bluetooth). Nếu chưa, việc start (và trigger popup quyền)
///      dời sang lúc user bấm "Tiếp tục" ở OnboardingBloc — tránh popup
///      Bluetooth bật bất ngờ trước khi có màn giải thích.
///   4. SosBackgroundSync — bắt đầu lắng nghe mesh + connectivity, chạy
///      suốt vòng đời app, không gắn với 1 màn hình cụ thể nào. An toàn để
///      subscribe trước cả khi MeshService chưa start — chỉ đơn giản chưa
///      nhận được event nào cho tới lúc đó.
///
/// Trả về route khởi đầu cho GoRouter: `/onboarding` nếu đây là lần đầu,
/// `/` (màn SOS) nếu đã qua onboarding từ trước.
Future<String> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  Hive.registerAdapter(SosRequestDtoAdapter());
  await Hive.openBox<SosRequestDto>(sosBoxName);
  await Hive.openBox(settingsBoxName);

  getIt.registerSingleton<AppConfig>(
    AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080',
      bridgefyApiKey: dotenv.env['BRIDGEFY_API_KEY'] ?? '',
    ),
  );

  await configureDependencies();

  final hasSeenOnboarding = await getIt<HasSeenOnboardingUseCase>()(
    const NoParams(),
  );

  if (hasSeenOnboarding) {
    try {
      final meshService = getIt<MeshService>();
      await meshService.start(apiKey: getIt<AppConfig>().bridgefyApiKey);
    } catch (e) {
      AppLogger.warning('Mesh service không khởi động được lúc bootstrap: $e');
    }
  }

  getIt<SosBackgroundSync>().start();

  return hasSeenOnboarding ? AppRoute.sos : AppRoute.onboarding;
}
