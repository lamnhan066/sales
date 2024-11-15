import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/presentation/riverpod/notifiers/app_settings_provider.dart';
import 'package:sales/presentation/riverpod/notifiers/login_provider.dart';
import 'package:sales/presentation/riverpod/notifiers/settings_provider.dart';
import 'package:sales/presentation/views/home_view.dart';
import 'package:sales/presentation/widgets/licenses.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool isShowingAutoCheckAndLogin = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await (
        ref.read(appSettingsProvider.notifier).initialize(),
        ref.read(settingsProvider.notifier).initialize(),
        ref.read(loginProvider.notifier).initialize(),
      ).wait;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    if (loginState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginState.showAutoLoginDialog && loginState.rememberMe) {
        _checkAndLoginAutomatically(context, loginNotifier);
      }
    });

    usernameTextController.text = loginState.username;
    passwordTextController.text = loginState.password;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    Text(
                      'Chào mừng bạn trở lại!'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
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
                  controller: usernameTextController,
                  onChanged: loginNotifier.updateUsername,
                  title: 'Tên tài khoản'.tr,
                ),
                BoxWInput(
                  obscureText: true,
                  controller: passwordTextController,
                  onChanged: loginNotifier.updatePassword,
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
                    onTap: loginNotifier.toggleRememberMe,
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
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final isLoggedIn = await loginNotifier.login();
                        if (isLoggedIn) {
                          _navigateToHomeView();
                        }
                      },
                      child: Text('Đăng Nhập'.tr),
                    ),
                  ),
                ),
                const Divider(),
                Center(child: buildLicense(ref)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showConfigurationDialog(
                          context,
                          loginNotifier,
                          loginState.serverConfigurations,
                        );
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
                        'Phiên bản: @{version}'.trP({'version': loginState.version.version}),
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
    LoginNotifier configureServerNotifier,
    ServerConfigurations settings,
  ) async {
    var newSettings = settings;
    final result = await boxWDialog<bool>(
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

    if (result ?? false) {
      await configureServerNotifier.saveServerConfigurations(newSettings);
    }
  }

  /// Tự động kiểm tra và đăng nhập.
  Future<void> _checkAndLoginAutomatically(BuildContext context, LoginNotifier loginNotifier) async {
    if (isShowingAutoCheckAndLogin) {
      return;
    }
    isShowingAutoCheckAndLogin = true;

    Timer? timer;
    final isAutomaticallyLogin = await boxWDialog<bool>(
      context: context,
      content: Builder(
        builder: (context) {
          timer = Timer(const Duration(seconds: 3), () {
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
                  Navigator.pop(context, false);
                },
                child: Text('Huỷ'.tr),
              ),
            ],
          );
        },
      ),
    );
    timer?.cancel();
    loginNotifier.closeAutoLoginDialog();

    if (isAutomaticallyLogin ?? false) {
      final isLoggedIn = await loginNotifier.autoLogin();
      if (isLoggedIn) {
        _navigateToHomeView();
      }
    }
    isShowingAutoCheckAndLogin = false;
  }

  void _navigateToHomeView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(builder: (_) => const HomeView()),
    );
  }
}
