import 'package:boxw/boxw.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart' hide DataTable, DataRow, DataColumn, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/presentation/riverpod/notifiers/orders_provider.dart';
import 'package:sales/presentation/riverpod/states/orders_state.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';
import 'package:sales/presentation/widgets/order_dialog.dart';
import 'package:sales/presentation/widgets/order_filter_dialog.dart';
import 'package:sales/presentation/widgets/page_chooser_dialog.dart';
import 'package:sales/presentation/widgets/toolbar.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).initialize();
      ref.read(ordersProvider).tour.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final ordersNotifier = ref.read(ordersProvider.notifier);

    if (ordersState.isLoading) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Column(
        children: [
          Toolbar(
            leadings: [
              FeaturesTour(
                controller: ordersState.tour,
                index: 1,
                introduce: Text('Nhấn vào đây để thêm đơn hàng'.tr),
                child: FilledButton(
                  onPressed: addOrder,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
            trailings: [
              FeaturesTour(
                controller: ordersState.tour,
                index: 2,
                introduce: Text('Nhấn vào đây để mở tuỳ chọn lọc đơn hàng'.tr),
                child: IconButton(
                  onPressed: filter,
                  icon: ordersState.dateRange == null
                      ? const Icon(Icons.filter_alt_off_rounded)
                      : const Icon(Icons.filter_alt_rounded),
                ),
              ),
            ],
          ),
          if (ordersState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (ordersState.error.isNotEmpty)
            Center(child: Text('Error: ${ordersState.error}'))
          else
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    dataRowMinHeight: 68,
                    dataRowMaxHeight: 68,
                    columnSpacing: 30,
                    horizontalMargin: 10,
                    columnWidthBuilder: (index) {
                      if (index == 1) {
                        return const IntrinsicColumnWidth(flex: 1);
                      }
                      return null;
                    },
                    columns: _buildColumns(),
                    rows: _buildRows(ordersState, ordersNotifier),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: ordersState.page == 1
                      ? null
                      : () {
                          ordersNotifier.goToPreviousPage();
                        },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                IconButton(
                  onPressed: () {
                    choosePage();
                  },
                  icon: Text('${ordersState.page}/${ordersState.totalPage}'),
                ),
                IconButton(
                  onPressed: ordersState.page == ordersState.totalPage
                      ? null
                      : () {
                          ordersNotifier.goToNextPage();
                        },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('STT'.tr, textAlign: TextAlign.center),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('Ngày Giờ'.tr, textAlign: TextAlign.center),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('Trạng Thái'.tr, textAlign: TextAlign.center),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('Hành động'.tr, textAlign: TextAlign.center),
      ),
    ];
  }

  List<DataRow> _buildRows(OrdersState ordersState, OrdersNotifier ordersNotifier) {
    return ordersState.orders.asMap().entries.map((entry) {
      final index = entry.key;
      final order = entry.value;

      return DataRow(
        cells: [
          DataCell(
            Center(
              child: Text(
                '${(ordersState.page - 1) * ordersState.perPage + index + 1}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                order.date.toHHmmssddMMyyyy(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                order.status.text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeaturesTour(
                    enabled: index == 0,
                    controller: ordersState.tour,
                    index: 3,
                    introduce: Text('Nhấn vào đây để xem chi tiết đơn hàng'.tr),
                    child: IconButton(
                      onPressed: () {
                        viewOrder(order);
                      },
                      icon: const Icon(Icons.info_rounded),
                    ),
                  ),
                  FeaturesTour(
                    enabled: index == 0,
                    controller: ordersState.tour,
                    index: 4,
                    introduce: Text('Nhấn vào đây để cập nhật chi tiết đơn hàng'.tr),
                    child: IconButton(
                      onPressed: () {
                        updateOrder(order);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  FeaturesTour(
                    enabled: index == 0,
                    controller: ordersState.tour,
                    index: 5,
                    introduce: Text('Nhấn vào đây để sao chép chi tiết đơn hàng'.tr),
                    child: IconButton(
                      onPressed: () {
                        copyOrder(order);
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ),
                  FeaturesTour(
                    enabled: index == 0,
                    controller: ordersState.tour,
                    index: 6,
                    introduce: Text('Nhấn vào đây để xoá đơn hàng'.tr),
                    child: IconButton(
                      onPressed: () {
                        removeOrder(order);
                      },
                      icon: const Icon(Icons.close_rounded, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  void viewOrder(Order order) async {
    final notifier = ref.read(ordersProvider.notifier);
    viewOrderDialog(
      context: context,
      notifier: notifier,
      order: order,
    );
  }

  Future<void> updateOrder(Order order) async {
    final notifier = ref.read(ordersProvider.notifier);
    final result = await updateOrderDialog(
      context: context,
      notifier: notifier,
      order: order,
    );

    if (result != null) {
      await notifier.updateOrderWithItems(result.order, result.orderItems);
    }
  }

  Future<void> copyOrder(Order order) async {
    final notifier = ref.read(ordersProvider.notifier);
    final result = await copyOrderDialog(
      context: context,
      notifier: notifier,
      order: order,
    );

    if (result != null) {
      await notifier.addOrderWithItems(result.order, result.orderItems);
    }
  }

  Future<void> removeOrder(Order order) async {
    final notifier = ref.read(ordersProvider.notifier);
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá đơn này không?'.tr,
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await notifier.removeOrderWithItems(order);
    }
  }

  Future<void> addOrder() async {
    final notifier = ref.read(ordersProvider.notifier);
    final result = await addOrderDialog(
      context: context,
      notifier: notifier,
    );

    if (result != null) {
      await notifier.addOrderWithItems(result.order, result.orderItems);
    }
  }

  Future<void> choosePage() async {
    final notifier = ref.read(ordersProvider.notifier);
    final state = ref.watch(ordersProvider);

    final newPage = await pageChooser(
      context: context,
      page: state.page,
      totalPage: state.totalPage,
    );

    if (newPage != null) {
      await notifier.goToPage(newPage);
    }
  }

  Future<void> filter() async {
    final notifier = ref.read(ordersProvider.notifier);
    final state = ref.watch(ordersProvider);

    var newDateRange = state.dateRange;
    final result = await boxWDialog<bool>(
      context: context,
      title: 'Bộ lọc'.tr,
      content: OrderFilterDialog(
        initialDateRange: newDateRange,
        onDateRangeChanged: (dateRange) {
          newDateRange = dateRange;
        },
      ),
      buttons: (context) {
        return [
          confirmCancelButtons(
            context: context,
            confirmText: 'OK'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    if (result == true) {
      await notifier.updateFilters(newDateRange);
    }
  }
}
