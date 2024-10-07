import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';
import 'package:sales/presentation/providers/login_provider.dart';
import 'package:sales/presentation/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller cho màn hình Home.
class HomeController {
  final _prefs = getIt<SharedPreferences>();

  ViewsModel _view = ViewsModel.dashboard;

  /// Màn hình hiện tại
  ViewsModel get view => _view;

  /// Khởi tạo
  Future<void> initial() async {
    _view = ViewsModel.values.byName(_prefs.getString('LastView') ?? ViewsModel.dashboard.name);
  }

  /// Thay đổi màn hình.
  void setView(ViewsModel view, void Function(void Function()) setState) {
    _prefs.setString('LastView', view.name);
    setState(() {
      _view = view;
    });
  }

  void logout(BuildContext context, WidgetRef ref) {
    ref.read(loginProvider.notifier).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }
}
