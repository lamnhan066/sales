import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/login_controller.dart';
import 'package:sales/di.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = getIt<LoginController>();

  @override
  void initState() {
    controller.initial(context, setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
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
                  title: 'Tên tài khoản'.tr,
                  textAlign: TextAlign.left,
                  initial: controller.username,
                  onChanged: (username) {
                    controller.onUsernameChanged(context, setState, username);
                  },
                ),
                BoxWInput(
                  title: 'Mật khẩu'.tr,
                  textAlign: TextAlign.left,
                  initial: controller.password,
                  obscureText: true,
                  onChanged: (pw) {
                    controller.onPasswordChanged(context, setState, pw);
                  },
                ),
                if (controller.error.isNotEmpty)
                  Text(
                    controller.error,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      controller.onRememberCheckboxChanged(context, setState);
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: controller.rememberMe,
                          onChanged: (value) {
                            controller.onRememberCheckboxChanged(
                              context,
                              setState,
                              value,
                            );
                          },
                        ),
                        Text('Nhớ thông tin của tôi'.tr)
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
                        controller.onLoginButtonTapped(context, setState);
                      },
                      child: Text('Đăng Nhập'.tr),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.serverConfiguration(context);
                      },
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.settings),
                          ),
                          Text('Cấu hình máy chủ'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'Phiên bản: ${controller.version}',
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
}
