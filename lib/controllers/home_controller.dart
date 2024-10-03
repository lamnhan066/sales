import 'package:flutter/material.dart';
import 'package:sales/di.dart';
import 'package:sales/models/views_model.dart';
import 'package:sales/views/dashboard.dart';
import 'package:sales/views/orders.dart';
import 'package:sales/views/products.dart';
import 'package:sales/views/report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  final prefs = getIt<SharedPreferences>();
  ViewsModel get view => _view;
  ViewsModel _view = ViewsModel.dashboard;

  Future<void> initial() async {
    _view = ViewsModel.values
        .byName(prefs.getString('LastView') ?? ViewsModel.dashboard.name);
  }

  Future<void> dispose() async {}

  Widget getView() {
    return switch (_view) {
      ViewsModel.dashboard => const DashboardView(),
      ViewsModel.orders => const OrdersView(),
      ViewsModel.products => const ProductsView(),
      ViewsModel.report => const ReportView(),
    };
  }

  void setView(ViewsModel view, Function setState) {
    prefs.setString('LastView', view.name);
    setState(() {
      _view = view;
    });
  }
}
