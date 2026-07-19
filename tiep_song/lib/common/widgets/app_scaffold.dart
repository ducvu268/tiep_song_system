import 'package:flutter/material.dart';
import 'package:tiep_song/common/constants/app_color.dart';

/// Cung cấp background color đồng nhất + resizeToAvoidBottomInset mặc định
/// true (keyboard không che input khi nhập số người/ghi chú SOS).
/// KHÔNG bọc SafeArea — mỗi màn hình tự quyết định, giống convention gốc.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
