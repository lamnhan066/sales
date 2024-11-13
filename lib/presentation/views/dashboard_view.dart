import 'package:boxw/boxw.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart' hide DataCell, DataColumn, DataRow, DataTable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/core/extensions/price_extensions.dart';
import 'package:sales/core/utils/date_time_utils.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/notifiers/dashboard_provider.dart';
import 'package:sales/presentation/riverpod/states/dashboard_state.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToolbar(context, dashboardState, dashboardNotifier),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTotalProducts(divider, dashboardState),
                          _buildDailyOrders(divider, dashboardState),
                          _buildDailyRevenue(divider, dashboardState),
                        ],
                      ),
                      _buildSalesReport(divider, dashboardState),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildThreeRecentOrdersDetails(divider, dashboardState),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildDailyRevenueForMonth(dashboardState),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          BoxWRect(
            borderColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Sparkline(
                data: dashboardState.dailyRevenueForMonth.map((e) => e.toDouble()).toList(),
                gridLinesEnable: true,
                gridLinelabel: (gridLineValue) {
                  return '${(gridLineValue / 1000).round()}k';
                },
                xLabels: [
                  for (int i = 1; i <= dashboardState.dailyRevenueForMonth.length; i++) '$i',
                ],
                xLabelsStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Chi tiết 3 đơn hàng gần nhất'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            divider,
            Builder(builder: (context) {
              final orderItems = dashboardState.threeRecentOrders.orderItems;
              final products = dashboardState.threeRecentOrders.products;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final order in orderItems.keys)
                    BoxWRect(
                      borderColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              DateTimeUtils.formatDateTime(order.date),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            divider,
                            DataTable(
                              dataRowMinHeight: 68,
                              dataRowMaxHeight: 68,
                              columnSpacing: 30,
                              horizontalMargin: 10,
                              columns: _buildDataColumns(),
                              rows: [
                                for (int i = 0; i < orderItems[order]!.length; i++)
                                  _buildDataRows(products[order]!, orderItems[order]!, i),
                                _buildTotalPrice(products[order]!, orderItems[order]!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return <DataColumn>[
      DataColumn(label: Text('Tên Sản Phẩm'.tr)),
      DataColumn(numeric: true, label: Text('Số Lượng'.tr)),
      DataColumn(numeric: true, label: Text('Thành Tiền'.tr)),
    ];
  }

  DataRow _buildDataRows(
    List<Product> products,
    List<OrderItem> orderItems,
    int i,
  ) {
    final orderItem = orderItems.elementAt(i);
    final product = products.elementAt(i);
    return DataRow(
      cells: [
        DataCell(
          Text(product.name),
        ),
        DataCell(
          Text('${orderItem.quantity}'),
        ),
        DataCell(
          Text(orderItem.totalPrice.toPriceDigit()),
        ),
      ],
    );
  }

  DataRow _buildTotalPrice(
    List<Product> products,
    List<OrderItem> orderItems,
  ) {
    var total = 0;
    for (final orderItem in orderItems) {
      total += orderItem.totalPrice;
    }
    return DataRow(
      cells: [
        const DataCell(Text('')),
        const DataCell(Text('Tổng cộng')),
        DataCell(Text(total.toPriceDigit())),
      ],
    );
  }

  Row _buildSalesReport(Widget divider, DashboardState dashboardState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Top 5 sản phẩm bán chạy'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                divider,
                DataTable(
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 68,
                  columnSpacing: 30,
                  horizontalMargin: 10,
                  columns: const [
                    IntrinsicDataColumn(label: Text('Tên sản phẩm')),
                    DataColumn(numeric: true, label: Text('Số lượng')),
                  ],
                  rows: [
                    for (final product in dashboardState.fiveHighestSalesProducts.entries)
                      DataRow(cells: [
                        DataCell(Text(product.key.name)),
                        DataCell(Text('${product.value}')),
                      ],),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Top 5 sản phẩm sắp hết hàng'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                divider,
                DataTable(
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 68,
                  columnSpacing: 30,
                  horizontalMargin: 10,
                  columns: const [
                    IntrinsicDataColumn(label: Text('Tên sản phẩm')),
                    DataColumn(numeric: true, label: Text('Số lượng')),
                  ],
                  rows: [
                    for (final product in dashboardState.fiveLowStockProducts)
                      DataRow(cells: [
                        DataCell(Text(product.name)),
                        DataCell(Text('${product.count}')),
                      ],),
                  ],
                ),
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Tổng doanh thu trong ngày'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            divider,
            Text(
              '@{dailyRevenue} đồng'.trP({
                'dailyRevenue': dashboardState.dailyRevenue.toPriceDigit(),
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Tổng số đơn hàng trong ngày'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Tổng số sản phẩm'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
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
