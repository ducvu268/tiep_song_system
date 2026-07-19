import 'package:flutter/material.dart';

/// | Role     | Size | Height | Weight   |
/// |----------|------|--------|----------|
/// | display  | 30   | 34     | Bold     |
/// | h1       | 26   | 32     | Bold     |
/// | h2       | 20   | 26     | Bold     |
/// | h3       | 16   | 22     | SemiBold |
/// | body     | 14   | 20     | Regular  |
/// | subtitle | 12   | 16     | Regular  |
/// | button   | 15   | —      | SemiBold |
///
/// Màn hình SOS dùng `display`/`h1` cho label to — người dùng có thể đang
/// cầm điện thoại tay run, cần đọc được ở khoảng cách xa hơn bình thường.
abstract final class AppTextStyle {
  static const String _fontFamily = 'Roboto';

  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 30,
    height: 34 / 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 26,
    height: 32 / 26,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}
