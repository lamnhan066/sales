import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/presentation/providers/configuration_provider.dart';
import 'package:sales/presentation/providers/login_provider.dart';
import 'package:sales/views/home_view.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);
    final configureServerNotifier = ref.read(postgresConfigurationsProvider.notifier);
    final configureServerState = ref.watch(postgresConfigurationsProvider);

    if (loginState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      });
    }

    if (configureServerState.showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showConfigurationDialog(context, configureServerNotifier, configureServerState.configurations);
      });
    }

    if (loginState.showAutoLoginDialog && loginState.rememberMe) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndLoginAutomatically(context, loginNotifier);
      });
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: Colors.purple,
              child: Center(
                child: Text(
                  'Chào mừng bạn trở lại!'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(title: Text('Đăng nhập'.tr)),
                Text(
                  'Chào mừng bạn đã trở lại! Vui lòng đăng nhập để tiếp tục'.tr,
                ),
                BoxWInput(
                  initial: loginState.username,
                  onChanged: (value) => loginNotifier.updateUsername(value),
                  title: 'Tên tài khoản'.tr,
                ),
                BoxWInput(
                  obscureText: true,
                  initial: loginState.password,
                  onChanged: (value) => loginNotifier.updatePassword(value),
                  title: 'Mật khẩu'.tr,
                ),
                if (loginState.error.isNotEmpty)
                  Text(
                    loginState.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      loginNotifier.toggleRememberMe();
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: loginState.rememberMe,
                          onChanged: (value) => loginNotifier.toggleRememberMe(),
                        ),
                        Text('Nhớ thông tin của tôi'.tr),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        loginNotifier.login();
                      },
                      child: Text('Đăng Nhập'.tr),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        configureServerNotifier.requestServerConfigurationDialog();
                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.settings),
                          ),
                          Text('Cấu hình máy chủ'.tr),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'Phiên bản: ${loginState.version.version}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfigurationDialog(
    BuildContext context,
    ServerConfigurationNotifier configureServerNotifier,
    ServerConfigurations settings,
  ) async {
    ServerConfigurations newSettings = settings;
    final result = await boxWDialog(
      context: context,
      title: 'Cấu Hình Máy Chủ'.tr,
      content: Column(
        children: [
          BoxWInput(
            title: 'host',
            initial: newSettings.host,
            onChanged: (value) {
              newSettings = newSettings.copyWith(host: value);
            },
          ),
          BoxWInput(
            title: 'database',
            initial: newSettings.database,
            onChanged: (value) {
              newSettings = newSettings.copyWith(database: value);
            },
          ),
          BoxWInput(
            title: 'username',
            initial: newSettings.username,
            onChanged: (value) {
              newSettings = newSettings.copyWith(username: value);
            },
          ),
          BoxWInput(
            title: 'password',
            initial: newSettings.password,
            obscureText: true,
            onChanged: (value) {
              newSettings = newSettings.copyWith(password: value);
            },
          ),
        ],
      ),
      buttons: (_) {
        return [
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Lưu'.tr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Huỷ'.tr),
                ),
              ),
            ],
          ),
        ];
      },
    );

    if (result == true) {
      await configureServerNotifier.saveConfigurations(newSettings);
    } else {
      configureServerNotifier.closeDialog();
    }
  }

  /// Tự động kiểm tra và đăng nhập.
  Future<void> _checkAndLoginAutomatically(BuildContext context, LoginNotifier loginNotifier) async {
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

    loginNotifier.closeAutoLoginDialog();

    if (isAutomaticallyLogin == true) {
      loginNotifier.autoLogin();
    }
  }
}
