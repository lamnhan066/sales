import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/home_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = getIt<HomeController>();
  bool loading = true;

  @override
  void initState() {
    controller.initial().then((_) {
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

    final tab = SizedBox(
      width: 220,
      child: NavigationDrawer(children: [
        AppBar(
          automaticallyImplyLeading: false,
        ),
        for (final view in ViewsModel.values)
          ListTile(
            tileColor:
                controller.view == view ? Theme.of(context).primaryColor : null,
            textColor: controller.view == view
                ? Theme.of(context).colorScheme.onPrimary
                : null,
            title: Text(title(view)),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 12,
              color: controller.view == view
                  ? Theme.of(context).colorScheme.onPrimary
                  : null,
            ),
            onTap: () {
              controller.setView(view, setState);
            },
          ),
      ]),
    );

    return Scaffold(
      drawer: tab,
      body: Row(
        children: [
          tab,
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title(controller.view)),
                ),
                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.getView(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
