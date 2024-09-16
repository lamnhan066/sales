import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/product.dart';
import 'package:sales/services/database/test_database.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final database = getIt<TestDatabase>();

  int totalProductCount = 0;
  List<Product> fiveLowStockProducts = [];
  List<Product> fiveHighestSalesProducts = [];
  int dailyOrderCount = 0;
  int dailyRevenue = 0;
  List<Order> threeRecentOrders = [];

  @override
  void initState() {
    () async {
      database.getTotalProductCount().then((value) {
        setState(() {
          totalProductCount = value;
        });
      });
      database.getFiveLowStockProducts().then((value) {
        setState(() {
          fiveLowStockProducts = value;
        });
      });
      database.getFiveHighestSalesProducts().then((value) {
        setState(() {
          fiveHighestSalesProducts = value;
        });
      });
      database.getDailyOrderCount(DateTime.now()).then((value) {
        setState(() {
          dailyOrderCount = value;
        });
      });
      database.getDailyRevenue(DateTime.now()).then((value) {
        setState(() {
          dailyRevenue = value;
        });
      });
      database.getThreeRecentOrders().then((value) {
        setState(() {
          threeRecentOrders = value;
        });
      });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tổng Quan'.tr)),
      body: Column(
        children: [
          Text('Tổng số sản phẩm: $totalProductCount'),
          Text(
              'Top 5 sản phẩm sắp hết hàng (số lượng < 5): $fiveLowStockProducts'),
          Text('Top 5 sản phẩm bán chạy: $fiveHighestSalesProducts'),
          Text('Tổng số đơn hàng trong ngày: $dailyOrderCount'),
          Text('Tổng doanh thu trong ngày: $dailyRevenue'),
          Text('Chi tiết 3 đơn hàng gần nhất: $threeRecentOrders'),
          const Text('Biểu đồ doanh thu theo ngày trong tháng hiện tại'),
        ],
      ),
    );
  }
}
