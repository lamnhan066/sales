import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/services/utils.dart';
import 'package:sales/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  String username = '';
  String password = '';
  bool rememberMe = true;
  String version = '1.0.0';
  String error = '';

  Future<void> initial(BuildContext context, Function setState) async {
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

  void checkAndLoginAutomatically(BuildContext context) async {
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey('Login.Username')) return;

    final isAutomaticallyLogin = await boxWDialog(
      context: context,
      content: Builder(builder: (context) {
        final timer = Timer(const Duration(seconds: kReleaseMode ? 3 : 0), () {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
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
            )
          ],
        );
      }),
    );

    if (isAutomaticallyLogin && context.mounted) {
      login(context, username, password, true);
    }
  }

  void login(
    BuildContext context,
    username,
    String password,
    bool rememberMe, [
    Function? setState,
  ]) async {
    if (rememberMe) {
      _saveRememberedPassword(username, password);
    } else {
      _removeRememberedPassword();
    }
    if (username == 'admin' && password == '0000') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (setState != null) {
        setState(() {
          error = 'Tên tài khoản hoặc mật khẩu không đúng'.tr;
        });
      }
    }
  }

  void serverConfiguration(BuildContext context) async {
    getIt<AppController>().settingsDialog(context);
  }

  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  (String username, String password) readRememberedInformation() {
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey('Login.Username')) {
      return ('', '');
    }
    final username = prefs.getString('Login.Username') ?? '';
    final encryptedPassword = prefs.getString('Login.Password') ?? '';
    final password = PasswordCryptor.decrypt(username, encryptedPassword);
    return (username, password);
  }

  void _saveRememberedPassword(String username, String password) {
    final prefs = getIt<SharedPreferences>();
    prefs.setString('Login.Username', username);
    prefs.setString(
        'Login.Password', PasswordCryptor.encrypt(username, password));
  }

  void _removeRememberedPassword() {
    final prefs = getIt<SharedPreferences>();
    prefs.remove('Login.Username');
    prefs.remove('Login.Password');
  }

  void onUsernameChanged(
    BuildContext context,
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

  void onPasswordChanged(
    BuildContext context,
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

  void onRememberCheckboxChanged(
    BuildContext context,
    void Function(VoidCallback fn) setState, [
    bool? value,
  ]) {
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

  void onLoginButtonTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) {
    login(
      context,
      username,
      password,
      rememberMe,
      setState,
    );
  }
}
