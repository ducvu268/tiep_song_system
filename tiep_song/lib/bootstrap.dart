import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiep_song/common/config/app_config.dart';
import 'package:tiep_song/common/di/injector.dart';
import 'package:tiep_song/common/services/mesh_service.dart';
import 'package:tiep_song/features/sos/data/datasources/sos_local_datasource.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';
import 'package:tiep_song/features/sos/domain/services/sos_background_sync.dart';
import 'package:tiep_song/features/settings/data/datasources/settings_local_datasource.dart';

/// Thứ tự khởi tạo có chủ đích:
///   1. Hive trước tiên — nếu bước sau lỗi, local storage vẫn sẵn sàng
///      nhận dữ liệu (không có gì tệ hơn app crash lúc khởi động mà
///      không lưu được SOS).
///   2. DI container.
///   3. Mesh service start — cố gắng nhưng KHÔNG chặn app khởi động nếu
///      Bluetooth bị tắt/thiếu quyền; UI sẽ tự hiện cảnh báo riêng.
///   4. SosBackgroundSync — bắt đầu lắng nghe mesh + connectivity, chạy
///      suốt vòng đời app, không gắn với 1 màn hình cụ thể nào.
Future<void> bootstrap() async {
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

  try {
    final meshService = getIt<MeshService>();
    await meshService.start(apiKey: getIt<AppConfig>().bridgefyApiKey);
  } catch (e) {
    debugPrint('Mesh service không khởi động được lúc bootstrap: $e');
  }

  getIt<SosBackgroundSync>().start();
}
