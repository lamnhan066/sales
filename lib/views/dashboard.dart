import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/dashboard_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/services/utils.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final controller = getIt<DashboardController>();

  @override
  void initState() {
    controller.initial(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = const SizedBox(width: 100, child: Divider());
    return Scaffold(
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
                            '@{count} sản phẩm'.trP({
                              'count': controller.totalProductCount,
                            }),
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
                            '@{count} đơn'.trP({
                              'count': controller.dailyOrderCount,
                            }),
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
                            '@{dailyRevenue} đồng'.trP({
                              'dailyRevenue': controller.dailyRevenue,
                            }),
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
                          for (final product
                              in controller.fiveHighestSalesProducts)
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
                          for (final product in controller.fiveLowStockProducts)
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
                          for (final order
                              in controller.threeRecentOrders.$1.keys)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(Utils.formatDateTime(order.date)),
                                    divider,
                                    for (int i = 0;
                                        i <
                                            controller.threeRecentOrders
                                                .$1[order]!.length;
                                        i++)
                                      Builder(builder: (_) {
                                        final orderItem = controller
                                            .threeRecentOrders.$1[order]!
                                            .elementAt(i);
                                        final product = controller
                                            .threeRecentOrders.$2[order]!
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
                            data: controller.monthlyRevenues
                                .map((e) => e.toDouble())
                                .toList(),
                            gridLinesEnable: true,
                            gridLinelabel: (gridLineValue) {
                              return '${(gridLineValue / 1000).round()}k';
                            },
                            xLabels: [
                              for (int i = 1;
                                  i <= controller.monthlyRevenues.length;
                                  i++)
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
