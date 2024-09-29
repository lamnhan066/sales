import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appController = getIt<AppController>();
  bool loading = true;

  @override
  void initState() {
    loadSetup().then((_) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title(ViewsModel view) {
      return switch (view) {
        ViewsModel.dashboard => 'Tổng Quan'.tr,
        ViewsModel.orders => 'Đơn Hàng'.tr,
        ViewsModel.products => 'Sản Phẩm'.tr,
        ViewsModel.report => 'Báo Cáo'.tr,
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title(appController.view)),
      ),
      drawer: NavigationDrawer(children: [
        for (final view in ViewsModel.values)
          FilledButton(
            onPressed: () {
              appController.setView(view, setState);
            },
            child: Text(title(view)),
          ),
      ]),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : appController.getView(),
    );
  }
}
