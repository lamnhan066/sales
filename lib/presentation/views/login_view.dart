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
  bool isShowingAutoCheckAndLogin = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(settingsProvider.notifier).initialize();
      ref.read(loginProvider.notifier).initialize();
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
                      padding: const EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
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

    if (isAutomaticallyLogin == true) {
      final isLoggedIn = await loginNotifier.autoLogin();
      if (isLoggedIn) {
        _navigateToHomeView();
      }
    }
    isShowingAutoCheckAndLogin = false;
  }

  Widget _buildLicense(LoginNotifier notifier, LoginState state) {
    return !state.isLoggedIn
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: switch (state.license) {
              ActiveLicense() => _buildActiveLicense(state),
              TrialLicense() => _buildTrialLicense(notifier, state),
              NoLicense() => _buildNoLicense(notifier, state),
            },
          );
  }

  Column _buildActiveLicense(LoginState state) {
    return Column(
      children: [
        Text('Bạn đang sử dụng bản quyền. Còn @{day} ngày.'.trP({
          'day': state.license.remainingDays,
        })),
        FilledButton(
          onPressed: null,
          child: Text('Kích Hoạt'.tr),
        ),
      ],
    );
  }

  Widget _buildTrialLicense(LoginNotifier notifier, LoginState state) {
    return state.license.isExpired
        ? _buildActivation(
            title: 'Bạn đã hết thời gian dùng thử.\nVui lòng nhập mã để kích hoạt ứng dụng'.tr,
            notifier: notifier,
            state: state,
          )
        : Column(
            children: [
              Text('Bạn đang sử dụng bản dùng thử. Còn @{day} ngày.'.trP({
                'day': state.license.remainingDays,
              })),
              FilledButton(
                onPressed: null,
                child: Text('Kích Hoạt'.tr),
              ),
            ],
          );
  }

  FutureBuilder<bool> _buildNoLicense(LoginNotifier notifier, LoginState state) {
    return FutureBuilder<bool>(
      future: notifier.canActiveTrial(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return snapshot.data!
            ? _buildTrialActivation(notifier, state)
            : _buildActivation(
                title: 'Bạn đã hết thời gian sử dụng.\nVui lòng nhập mã để kích hoạt ứng dụng'.tr,
                notifier: notifier,
                state: state,
              );
      },
    );
  }

  Column _buildTrialActivation(LoginNotifier notifier, LoginState state) {
    return Column(
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
    );
  }

  StatefulBuilder _buildActivation({
    required String title,
    required LoginNotifier notifier,
    required LoginState state,
  }) {
    String code = '';
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          BoxWInput(
            title: 'Mã kích hoạt'.tr,
            onChanged: (value) {
              setState(() => code = value);
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
  }

  void _navigateToHomeView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }
}
