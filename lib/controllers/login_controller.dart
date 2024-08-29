import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sales/di.dart';
import 'package:sales/services/utils.dart';
import 'package:sales/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  void checkAndLoginAutomatically(BuildContext context) async {
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey('Login.Username')) return;

    final isAutomaticallyLogin = await boxWDialog(
      context: context,
      content: Builder(builder: (context) {
        Timer(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        });
        return Column(
          children: [
            const CircularProgressIndicator(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Đang tự động đăng nhập...'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Huỷ'),
            )
          ],
        );
      }),
    );

    if (isAutomaticallyLogin && context.mounted) {
      final (username, password) = readRememberedInformation();
      login(context, username, password, true);
    }
  }

  void login(
    BuildContext context,
    username,
    String password,
    bool rememberMe,
  ) async {
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
    }
  }

  void serverConfiguration(BuildContext context) async {
    String server = getServer();
    final isSaved = await boxWDialog(
      context: context,
      title: 'Cấu hình máy chủ',
      content: Column(
        children: [
          BoxWInput(
            title: 'Máy chủ'.tr,
            initial: server,
            onChanged: (value) {
              server = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Huỷ'.tr),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Lưu'),
              ),
            ],
          )
        ],
      ),
    );

    if (isSaved == true) {
      final prefs = getIt<SharedPreferences>();
      prefs.setString('Settings.Server', server);
    }
  }

  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  String getServer() {
    final prefs = getIt<SharedPreferences>();
    return prefs.getString('Settings.Server') ?? '';
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
}
