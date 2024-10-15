import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/core/utils/date_time_utils.dart';
import 'package:sales/presentation/riverpod/notifiers/dashboard_provider.dart';
import 'package:sales/presentation/riverpod/states/dashboard_state.dart';

/// Màn hình tổng quan.
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardNotifierProvider.notifier).loadDashboardData();
      ref.read(dashboardNotifierProvider).tour.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardNotifier = ref.read(dashboardNotifierProvider.notifier);
    final dashboardState = ref.watch(dashboardNotifierProvider);

    if (dashboardState.isLoading) {
      return const SizedBox.shrink();
    }

    if (dashboardState.error.isNotEmpty) {
      return Center(child: Text('Error: ${dashboardState.error}'));
    }

    const Widget divider = SizedBox(width: 100, child: Divider());

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, dashboardState, dashboardNotifier),
          SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    _buildTotalProducts(divider, dashboardState),
                    _buildDailyOrders(divider, dashboardState),
                    _buildDailyRevenue(divider, dashboardState),
                  ],
                ),
                _buildSalesReport(divider, dashboardState),
                _buildThreeRecentOrdersDetails(divider, dashboardState),
                _buildDailyRevenueForMonth(dashboardState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, DashboardState state, DashboardNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: AppConfigs.toolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Row(
              children: [
                FeaturesTour(
                  controller: state.tour,
                  index: 1,
                  introduce: Text('Nhấn vào đây để chọn ngày thống kê ở trang tổng quan'.tr),
                  child: IconButton(
                    onPressed: () => _changeDate(state, notifier),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _buildDailyRevenueForMonth(DashboardState dashboardState) {
    return Card(
      child: Column(
        children: [
          Text(
            'Biểu đồ doanh thu theo ngày trong tháng @{month}'.trP(
              {'month': dashboardState.reportDateTime.tommyyyy()},
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 600,
                child: Sparkline(
                  data: dashboardState.dailyRevenueForMonth.map((e) => e.toDouble()).toList(),
                  gridLinesEnable: true,
                  gridLinelabel: (gridLineValue) {
                    return '${(gridLineValue / 1000).round()}k';
                  },
                  xLabels: [
                    for (int i = 1; i <= dashboardState.dailyRevenueForMonth.length; i++) '$i',
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card _buildThreeRecentOrdersDetails(Widget divider, DashboardState dashboardState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Chi tiết 3 đơn hàng gần nhất'.tr),
            divider,
            Builder(builder: (context) {
              final orderItems = dashboardState.threeRecentOrders.orderItems;
              final products = dashboardState.threeRecentOrders.products;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final order in orderItems.keys)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(DateTimeUtils.formatDateTime(order.date)),
                            divider,
                            for (int i = 0; i < orderItems[order]!.length; i++)
                              Builder(
                                builder: (_) {
                                  final orderItem = orderItems[order]!.elementAt(i);
                                  final product = products[order]!.elementAt(i);

                                  // TODO: Chỉnh sửa cách hiển thị đơn hàng để đẹp hơn
                                  return Text(
                                    '${product.name} - ${orderItem.quantity} - ${orderItem.totalPrice}',
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Row _buildSalesReport(Widget divider, DashboardState dashboardState) {
    return Row(
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
                for (final product in dashboardState.fiveHighestSalesProducts.entries)
                  Text(
                    '${product.key.name}: ${product.value}',
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
                for (final product in dashboardState.fiveLowStockProducts) Text('${product.name}: ${product.count}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Card _buildDailyRevenue(Widget divider, DashboardState dashboardState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Tổng doanh thu trong ngày'.tr),
            divider,
            Text(
              '@{dailyRevenue} đồng'.trP({
                'dailyRevenue': dashboardState.dailyRevenue,
              }),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildDailyOrders(Widget divider, DashboardState dashboardState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Tổng số đơn hàng trong ngày'.tr),
            divider,
            Text(
              '@{count} đơn'.trP({'count': dashboardState.dailyOrderCount}),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildTotalProducts(Widget divider, DashboardState dashboardState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Tổng số sản phẩm'.tr),
            divider,
            Text(
              '@{count} sản phẩm'.trP({'count': dashboardState.totalProductCount}),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeDate(DashboardState state, DashboardNotifier notifier) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.reportDateTime,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    await notifier.updateReportDate(date);
  }
}
