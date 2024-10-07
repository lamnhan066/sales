import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/home_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';
import 'package:sales/views/dashboard_view.dart';
import 'package:sales/views/orders_view.dart';
import 'package:sales/views/products_view.dart';
import 'package:sales/views/report_view.dart';
import 'package:sales/views/settings_view.dart';

/// Màn hình chính.
class HomeView extends StatefulWidget {
  /// Màn hình chính.
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = getIt<HomeController>();
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
    String title(ViewsModel view) {
      return switch (view) {
        ViewsModel.dashboard => 'Tổng Quan'.tr,
        ViewsModel.orders => 'Đơn Hàng'.tr,
        ViewsModel.products => 'Sản Phẩm'.tr,
        ViewsModel.report => 'Báo Cáo'.tr,
        ViewsModel.settings => 'Cài Đặt'.tr,
      };
    }

    final tab = SizedBox(
      width: 220,
      child: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final view in ViewsModel.values)
                      ListTile(
                        tileColor: controller.view == view ? Theme.of(context).primaryColor : null,
                        textColor: controller.view == view ? Theme.of(context).colorScheme.onPrimary : null,
                        title: Text(title(view)),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 12,
                          color: controller.view == view ? Theme.of(context).colorScheme.onPrimary : null,
                        ),
                        onTap: () {
                          controller.setView(view, setState);
                        },
                      ),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) => ListTile(
                title: Text('Đăng Xuất'.tr),
                onTap: () {
                  controller.logout(context, ref);
                },
              ),
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      final isBigScreen = constraints.maxWidth > 1000;
      return Scaffold(
        drawer: tab,
        body: Row(
          children: [
            if (isBigScreen) tab,
            Expanded(
              child: Column(
                children: [
                  AppBar(
                    title: Text(title(controller.view)),
                    automaticallyImplyLeading: !isBigScreen,
                  ),
                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : switch (controller.view) {
                            ViewsModel.dashboard => const DashboardView(),
                            ViewsModel.orders => const OrdersView(),
                            ViewsModel.products => const ProductsView(),
                            ViewsModel.report => const ReportView(),
                            ViewsModel.settings => const SettingsView(),
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
