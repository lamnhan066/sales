import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/presentation/views/login_view.dart';

/// Ứng dụng
class App extends StatefulWidget {
  /// Ứng dụng
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final controller = getIt<AppController>();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller.initial().then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  Text('Đang tải các dữ liệu cần thiết...'.tr),
                ],
              ),
            )
          : const LoginView(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
