import 'package:flutter/material.dart';

/// Bảng màu app cứu trợ: đỏ = khẩn cấp/SOS, cam = cảnh báo, xanh lá = an toàn/
/// đã xử lý. Ưu tiên tương phản cao — người dùng có thể thao tác dưới nắng
/// gắt, màn hình vỡ, hoặc trong lúc hoảng loạn.
abstract final class _Palette {
  static const emergencyRed = Color(0xFFD32F2F);
  static const emergencyRedDark = Color(0xFFB71C1C);
  static const alertAmber = Color(0xFFF2A619);
  static const safeGreen = Color(0xFF2E9E5B);
  static const meshTeal = Color(0xFF0D7E95); // trạng thái "đang qua mesh"

  static const paper = Color(0xFFF7F5F2);
  static const white = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFEDEAE5);
  static const border = Color(0xFFE0DCD5);
  static const ink = Color(0xFF201B17);
  static const textMuted = Color(0xFF6B6259);

  static const darkBg = Color(0xFF120E0C);
  static const darkSurface = Color(0xFF1E1815);
  static const darkSurface2 = Color(0xFF2A2320);
  static const darkBorder = Color(0xFF3A322C);
}

abstract final class AppColor {
  static const Color primary = _Palette.emergencyRed;
  static const Color primaryDark = _Palette.emergencyRedDark;
  static const Color warning = _Palette.alertAmber;
  static const Color success = _Palette.safeGreen;
  static const Color mesh = _Palette.meshTeal;

  static const Color background = _Palette.paper;
  static const Color surface = _Palette.white;
  static const Color surface2 = _Palette.surface2;

  static const Color border = _Palette.border;
  static const Color text = _Palette.ink;
  static const Color textMuted = _Palette.textMuted;
  static const Color textFaint = Color(0xFFB8B0A6);
  static const Color textOnPrimary = _Palette.white;

  static const Color white = _Palette.white;
  static const Color shadow = Color(0x1A201B17);

  /// Màu theo [SosSyncStatus] — dùng ở AppStatusPill trong danh sách SOS.
  static Color forSyncStatus(String syncStatus) => switch (syncStatus) {
    'pendingBroadcast' => warning,
    'relayedToMesh' => mesh,
    'syncedToServer' => success,
    _ => textMuted,
  };
}

abstract final class AppColorDark {
  static const Color background = _Palette.darkBg;
  static const Color surface = _Palette.darkSurface;
  static const Color surface2 = _Palette.darkSurface2;
  static const Color border = _Palette.darkBorder;
  static const Color text = Color(0xFFF3EFEA);
  static const Color textMuted = Color(0xFFA69C90);
}
