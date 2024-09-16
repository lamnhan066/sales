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
  final loginController = getIt<LoginController>();

  String username = '';
  String password = '';
  bool rememberMe = true;
  String version = '1.0.0';

  @override
  void initState() {
    getVersion();
    final remembered = loginController.readRememberedInformation();
    setState(() {
      username = remembered.$1;
      password = remembered.$2;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.checkAndLoginAutomatically(context);
    });
    super.initState();
  }

  void getVersion() async {
    final v = await loginController.getVersion();
    setState(() {
      version = v;
    });
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
                  initial: username,
                  onChanged: (un) {
                    username = un;
                  },
                ),
                BoxWInput(
                  title: 'Mật khẩu'.tr,
                  textAlign: TextAlign.left,
                  initial: password,
                  obscureText: true,
                  onChanged: (pw) {
                    password = pw;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        rememberMe = !rememberMe;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                rememberMe = value;
                              });
                            }
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
                        loginController.login(
                          context,
                          username,
                          password,
                          rememberMe,
                        );
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
                        loginController.serverConfiguration(context);
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
                        'Phiên bản: $version',
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
