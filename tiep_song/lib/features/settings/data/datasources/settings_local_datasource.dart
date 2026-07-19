import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const String settingsBoxName = 'settings';

const _keyContactName = 'contact_name';
const _keyContactPhone = 'contact_phone';

/// Chỉ 2 giá trị string đơn giản — dùng thẳng Box thô của Hive, không cần
/// DTO + TypeAdapter riêng (String đã được Hive hỗ trợ sẵn).
@injectable
class SettingsLocalDataSource {
  Box get _box => Hive.box(settingsBoxName);

  String? get contactName => _box.get(_keyContactName) as String?;

  String? get contactPhone => _box.get(_keyContactPhone) as String?;

  Future<void> saveContact({required String name, required String phone}) =>
      _box.putAll({_keyContactName: name, _keyContactPhone: phone});
}
