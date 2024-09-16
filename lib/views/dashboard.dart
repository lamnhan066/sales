import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/services/database/test_database.dart';
import 'package:sales/services/utils.dart';

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
  var threeRecentOrders =
      (<Order, List<OrderItem>>{}, <Order, List<Product>>{});
  List<int> monthlyRevenues = [];

  @override
  void initState() {
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
    database.getMonthlyRevenues(DateTime.now()).then((values) {
      monthlyRevenues = values;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = const SizedBox(width: 100, child: Divider());
    return Scaffold(
      appBar: AppBar(title: Text('Tổng Quan'.tr)),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Tổng số sản phẩm'.tr),
                          divider,
                          Text(
                            '$totalProductCount sản phẩm',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Tổng số đơn hàng trong ngày'.tr),
                          divider,
                          Text(
                            '$dailyOrderCount đơn',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Tổng doanh thu trong ngày'.tr),
                          divider,
                          Text(
                            '$dailyRevenue đồng',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Top 5 sản phẩm bán chạy'.tr),
                          divider,
                          for (final product in fiveHighestSalesProducts)
                            Text(
                              '${product.name}: ${product.count}',
                              style: const TextStyle(fontSize: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Top 5 sản phẩm sắp hết hàng (số lượng < 5)'.tr),
                          divider,
                          for (final product in fiveLowStockProducts)
                            Text('${product.name}: ${product.count}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Chi tiết 3 đơn hàng gần nhất'.tr),
                      divider,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final order in threeRecentOrders.$1.keys)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(Utils.formatDate(order.date)),
                                    divider,
                                    for (int i = 0;
                                        i < threeRecentOrders.$1[order]!.length;
                                        i++)
                                      Builder(builder: (_) {
                                        final orderItem = threeRecentOrders
                                            .$1[order]!
                                            .elementAt(i);
                                        final product = threeRecentOrders
                                            .$2[order]!
                                            .elementAt(i);

                                        return Text(
                                          '${product.name} - ${orderItem.quantity} - ${orderItem.totalPrice}',
                                        );
                                      }),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Text('Biểu đồ doanh thu theo ngày trong tháng hiện tại'.tr),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 600,
                          child: Sparkline(
                            data: monthlyRevenues.cast<double>(),
                            gridLinesEnable: true,
                            gridLinelabel: (gridLineValue) {
                              return '${(gridLineValue / 1000).round()}k';
                            },
                            xLabels: [
                              for (int i = 1; i <= monthlyRevenues.length; i++)
                                '$i',
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
