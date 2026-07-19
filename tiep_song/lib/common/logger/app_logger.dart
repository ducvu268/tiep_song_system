import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  static final Talker _talker = TalkerFlutter.init();

  static Talker get instance => _talker;

  static void info(String message) => _talker.info(message);

  static void error(String tag, Object error, [StackTrace? stack]) =>
      _talker.handle(error, stack, tag);

  static void warning(String message) => _talker.warning(message);
}
