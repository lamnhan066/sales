import 'package:flutter/material.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';
import 'package:sales/views/dashboard.dart';
import 'package:sales/views/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController {
  final prefs = getIt<SharedPreferences>();

  Future<void> initial() async {}

  Widget getLastView() {
    return switch (
        ViewsModel.values.byName(prefs.getString('LastView') ?? 'products')) {
      ViewsModel.dashboard => const DashboardView(),
      // TODO: Bổ sung màn hình Orders
      ViewsModel.orders => throw UnimplementedError(),
      ViewsModel.products => const ProductsView(),
      // TODO: Bổ sung màn hình Report
      ViewsModel.report => throw UnimplementedError(),
      // TODO: Bổ sung màn hình Setting
      ViewsModel.setting => throw UnimplementedError(),
    };
  }

  // TODO: Bổ sung vào các Navigation để có thể lưu được trạng thái màn hình mở cối
  void setLastView(ViewsModel view) {
    prefs.setString('LastView', view.name);
  }
}
