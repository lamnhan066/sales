import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/presentation/riverpod/notifiers/login_provider.dart';
import 'package:sales/presentation/riverpod/notifiers/settings_provider.dart';
import 'package:sales/presentation/riverpod/states/login_state.dart';
import 'package:sales/presentation/views/home_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(loginProvider.notifier).resetOnIntial();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginState = ref.watch(loginProvider);
      final loginNotifier = ref.read(loginProvider.notifier);

      ref.read(settingsProvider.notifier).initialize();

      if (loginState.showAutoLoginDialog && loginState.rememberMe) {
        _checkAndLoginAutomatically(context, loginNotifier);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    if (loginState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    usernameTextController.text = loginState.username;
    passwordTextController.text = loginState.password;

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
                  controller: usernameTextController,
                  onChanged: (value) => loginNotifier.updateUsername(value),
                  title: 'Tên tài khoản'.tr,
                ),
                BoxWInput(
                  obscureText: true,
                  controller: passwordTextController,
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
                _buildLicense(loginNotifier, loginState),
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

  // TODO: Hàm này chưa hoạt động được đúng như mong đợi vì `settings` trống.
  Future<void> _showConfigurationDialog(
    BuildContext context,
    LoginNotifier configureServerNotifier,
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
      await configureServerNotifier.saveServerConfigurations(newSettings);
    }
  }

  /// Tự động kiểm tra và đăng nhập.
  Future<void> _checkAndLoginAutomatically(BuildContext context, LoginNotifier loginNotifier) async {
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

    if (isAutomaticallyLogin == true) {
      final isLoggedIn = await loginNotifier.autoLogin();
      if (isLoggedIn) {
        _navigateToHomeView();
      }
    }
  }

  Widget _buildLicense(LoginNotifier notifier, LoginState state) {
    return !state.isLoggedIn
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: switch (state.license) {
              NoLicense() => FutureBuilder<bool>(
                  future: notifier.canActiveTrial(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    String code = '';

                    return snapshot.data!
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Bạn có 15 ngày để dùng thử.\nVui lòng nhấn Kích Hoạt để tiếp tục'.tr,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  notifier.activeTrial();
                                },
                                child: Text('Kích Hoạt'.tr),
                              ),
                              Text(
                                state.licenseError,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          )
                        : StatefulBuilder(builder: (context, setState) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Bạn đã hết thời gian dùng thử.\nVui lòng nhập mã để kích hoạt ứng dụng'.tr,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                BoxWInput(
                                  title: 'Mã kích hoạt'.tr,
                                  onChanged: (value) {
                                    code = value;
                                  },
                                ),
                                FilledButton(
                                  onPressed: code.isEmpty
                                      ? null
                                      : () {
                                          notifier.active(code);
                                        },
                                  child: Text('Kích Hoạt'.tr),
                                ),
                                Text(
                                  state.licenseError,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            );
                          });
                  },
                ),
              TrialLicense() => Column(
                  children: [
                    Text('Bạn đang sử dụng bản dùng thử. Còn @{day} ngày.'.trP({
                      'day': state.license.remainingDays,
                    })),
                    FilledButton(
                      onPressed: null,
                      child: Text('Kích Hoạt'.tr),
                    ),
                  ],
                ),
              ActiveLicense() => Column(
                  children: [
                    Text('Bạn đang sử dụng bản quyền. Còn @{day} ngày.'.trP({
                      'day': state.license.remainingDays,
                    })),
                    FilledButton(
                      onPressed: null,
                      child: Text('Kích Hoạt'.tr),
                    ),
                  ],
                ),
            },
          );
  }

  void _navigateToHomeView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }
}
