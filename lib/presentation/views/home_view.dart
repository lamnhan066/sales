import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/views_model.dart';
import 'package:sales/presentation/riverpod/notifiers/home_provider.dart';
import 'package:sales/presentation/views/dashboard_view.dart';
import 'package:sales/presentation/views/login_view.dart';
import 'package:sales/presentation/views/orders_view.dart';
import 'package:sales/presentation/views/products_view.dart';
import 'package:sales/presentation/views/report_view.dart';
import 'package:sales/presentation/views/settings_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    final bigScreen = MediaQuery.sizeOf(context).width > 1000;

    String title(ViewsModel view) {
      return switch (view) {
        ViewsModel.dashboard => 'Tổng Quan'.tr,
        ViewsModel.orders => 'Đơn Hàng'.tr,
        ViewsModel.products => 'Sản Phẩm'.tr,
        ViewsModel.report => 'Báo Cáo'.tr,
        ViewsModel.settings => 'Cài Đặt'.tr,
      };
    }

    Widget buildDrawer() {
      final colorScheme = Theme.of(context).colorScheme;
      return SizedBox(
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
                          selected: homeState.currentView == view,
                          selectedTileColor: colorScheme.inversePrimary,
                          title: Text(title(view)),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 12,
                          ),
                          onTap: () {
                            homeNotifier.setView(view);
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
                    homeNotifier.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildContent() {
      if (homeState.isLoading) {
        return const SizedBox.shrink();
      }

      return switch (homeState.currentView) {
        ViewsModel.dashboard => const DashboardView(),
        ViewsModel.orders => const OrdersView(),
        ViewsModel.products => const ProductsView(),
        ViewsModel.report => const ReportView(),
        ViewsModel.settings => const SettingsView(),
      };
    }

    return Scaffold(
      drawer: bigScreen ? null : buildDrawer(),
      body: Row(
        children: [
          if (bigScreen) buildDrawer(),
          Expanded(
              child: Column(
            children: [
              AppBar(
                title: Text(title(homeState.currentView)),
                automaticallyImplyLeading: !bigScreen,
              ),
              Expanded(
                child: buildContent(),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
