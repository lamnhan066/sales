import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/core/utils/password_cryptor.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller cho màn hình Login
class LoginController {
  /// Tên đăng nhập.
  String username = '';

  /// Mật khẩu.
  String password = '';

  /// Ghi nhớ tên đăng nhập và mật khẩu.
  bool rememberMe = true;

  /// Phiên bản ứng dụng.
  String version = '1.0.0';

  /// Lỗi.
  String error = '';

  /// Khởi tạo.
  Future<void> initial(
    BuildContext context,
    void Function(void Function()) setState,
  ) async {
    final v = await getVersion();
    setState(() {
      version = v;
    });
    final remembered = readRememberedInformation();
    setState(() {
      username = remembered.$1;
      password = remembered.$2;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndLoginAutomatically(context);
    });
  }

  /// Tự động kiểm tra và đăng nhập.
  Future<void> checkAndLoginAutomatically(BuildContext context) async {
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey('Login.Username')) return;

    final isAutomaticallyLogin = await boxWDialog<bool>(
      context: context,
      content: Builder(
        builder: (context) {
          final timer = Timer(const Duration(seconds: 3), () {
            Navigator.pop(context, true);
          });

          return Column(
            children: [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Đang tự động đăng nhập...'.tr),
              ),
              FilledButton(
                onPressed: () {
                  timer.cancel();
                  Navigator.pop(context, false);
                },
                child: Text('Huỷ'.tr),
              ),
            ],
          );
        },
      ),
    );

    if ((isAutomaticallyLogin ?? false) && context.mounted) {
      await login(
        context: context,
        username: username,
        password: password,
        rememberMe: true,
      );
    }
  }

  /// Đăng nhập.
  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
    required bool rememberMe,
    void Function(void Function())? setState,
  }) async {
    if (rememberMe) {
      _saveRememberedPassword(username, password);
    } else {
      _removeRememberedPassword();
    }
    if (username == 'admin' && password == '0000') {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } else {
      if (setState != null) {
        setState(() {
          error = 'Tên tài khoản hoặc mật khẩu không đúng'.tr;
        });
      }
    }
  }

  /// Cấu hình server.
  Future<void> serverConfiguration(BuildContext context) async {
    await getIt<AppController>().configuationsDialog(context);
  }

  /// Lấy phiên bản ứng dụng.
  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();

    return info.version;
  }

  /// Đọc dữ liệu đã lưu.
  (String username, String password) readRememberedInformation() {
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey('Login.Username')) {
      return ('', '');
    }
    final username = prefs.getString('Login.Username') ?? '';
    final encryptedPassword = prefs.getString('Login.Password') ?? '';
    final password = PasswordCryptor.decryptPassword(
      LoginCredentials(username: username, password: encryptedPassword),
    );

    return (username, password);
  }

  void _saveRememberedPassword(String username, String password) {
    final prefs = getIt<SharedPreferences>();
    prefs.setString('Login.Username', username);
    prefs.setString(
      'Login.Password',
      PasswordCryptor.encryptPassword(
        LoginCredentials(username: username, password: password),
      ),
    );
  }

  void _removeRememberedPassword() {
    final prefs = getIt<SharedPreferences>();
    prefs.remove('Login.Username');
    prefs.remove('Login.Password');
  }

  /// Calback khi thay đổi tên đăng nhập.
  void onUsernameChanged(
    void Function(VoidCallback fn) setState,
    String username,
  ) {
    this.username = username;

    if (error.isNotEmpty) {
      setState(() {
        error = '';
      });
    }
  }

  /// Calback khi thay đổi mật khẩu.
  void onPasswordChanged(
    void Function(VoidCallback fn) setState,
    String pw,
  ) {
    password = pw;

    if (error.isNotEmpty) {
      setState(() {
        error = '';
      });
    }
  }

  /// Calback khi thay đổi checbox ghi nhớ lần đăng nhập.
  void onRememberCheckboxChanged(
    void Function(VoidCallback fn) setState, {
    bool? value,
  }) {
    if (value == null) {
      setState(() {
        rememberMe = !rememberMe;
      });
    } else {
      setState(() {
        rememberMe = value;
      });
    }
  }

  /// Calback khi nhấp nút đăng nhập.
  void onLoginButtonTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) {
    login(
      context: context,
      username: username,
      password: password,
      rememberMe: rememberMe,
      setState: setState,
    );
  }
}
