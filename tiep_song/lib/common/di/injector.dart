import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

final getIt = GetIt.instance;

/// Sinh bởi injectable từ mọi annotation @injectable/@lazySingleton/@Injectable
/// rải rác trong common/ và features/. Chạy:
///   dart run build_runner build --delete-conflicting-outputs
/// để sinh `injector.config.dart` trước khi build app lần đầu, và mỗi khi
/// thêm/sửa 1 class có annotation DI.
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
