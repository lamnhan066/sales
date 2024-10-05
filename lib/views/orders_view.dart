// ignore_for_file: function_lines_of_code
import 'package:flutter/material.dart'
    hide DataTable, DataRow, DataColumn, DataCell;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/data_table_plus.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/utils/utils.dart';

/// Màn hình đơn hàng.
class OrdersView extends StatefulWidget {
  /// Màn hình đơn hàng.
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final controller = getIt<OrderController>();

  @override
  void initState() {
    super.initState();
    controller.initial(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: () {
                    controller.addOrder(context, setState);
                  },
                  child: const Icon(Icons.add),
                ),
                Row(
                  children: [
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.onFilterTapped(context, setState);
                      },
                      icon: const Icon(FontAwesomeIcons.filter),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                    return switch (index) {
                      1 => const IntrinsicColumnWidth(flex: 2),
                      2 => const IntrinsicColumnWidth(flex: 1),
                      _ => null,
                    };
                  },
                  columns: [
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'STT'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Ngày Giờ'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Trạng Thái'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Hành động'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: [
                    for (final o in controller.orders)
                      DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Text(
                                '${(controller.page - 1) * controller.perpage + controller.orders.indexOf(o) + 1}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                Utils.formatDateTime(o.date),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                o.status.text,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.infoOrder(
                                        context,
                                        setState,
                                        o,
                                      );
                                    },
                                    icon: const Icon(Icons.info_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.editOrder(
                                        context,
                                        setState,
                                        o,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.copyOrder(
                                        context,
                                        setState,
                                        o,
                                      );
                                    },
                                    icon: const Icon(Icons.copy),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.removeOrder(
                                        context,
                                        setState,
                                        o,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
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
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: controller.page == 1 || controller.totalPage == 0
                      ? null
                      : () {
                          controller.onPagePrevious(setState);
                        },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                if (controller.totalPage == 0)
                  const IconButton(
                    onPressed: null,
                    icon: Text('0/0'),
                  )
                else
                  IconButton(
                    onPressed: () {
                      controller.onPageChanged(context, setState);
                    },
                    icon: Text('${controller.page}/${controller.totalPage}'),
                  ),
                IconButton(
                  onPressed: controller.page == controller.totalPage ||
                          controller.totalPage == 0
                      ? null
                      : () {
                          controller.onPageNext(setState);
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
}
