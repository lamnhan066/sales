// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart'
    hide DataTable, DataRow, DataColumn, DataCell;
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/data_table_plus.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/order_status.dart';
import 'package:sales/models/product.dart';
import 'package:sales/utils/utils.dart';

class OrderFormDialog extends StatelessWidget {
  const OrderFormDialog({
    super.key,
    required this.controller,
    required this.form,
    required this.readOnly,
    required this.tempOrder,
    required this.orderItems,
    required this.orderItemProductMap,
    required this.validateForm,
  });

  final OrderController controller;
  final GlobalKey<FormState> form;
  final bool readOnly;
  final Order tempOrder;
  final List<OrderItem> orderItems;
  final Map<int, Product> orderItemProductMap;
  final VoidCallback validateForm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      onChanged: validateForm,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: BoxWInput(
                  readOnly: true,
                  initial: Utils.formatDateTime(tempOrder.date),
                  title: 'Ngày Giờ'.tr,
                ),
              ),
              Flexible(
                child: readOnly
                    ? BoxWInput(
                        readOnly: true,
                        title: 'Trạng thái'.tr,
                        initial: tempOrder.status.text,
                      )
                    : BoxWDropdown(
                        title: 'Trạng thái'.tr,
                        items: OrderStatus.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.text),
                              ),
                            )
                            .toList(),
                        value: tempOrder.status,
                        onChanged: (value) {
                          // TODO: Thay đổi trạng thái
                        },
                      ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(
                  builder: (_, tableState) {
                    int total = 0;
                    for (final order in orderItems) {
                      total += order.totalPrice;
                    }
                    return DataTable(
                      dataRowMinHeight: 68,
                      dataRowMaxHeight: 68,
                      columnSpacing: 20,
                      horizontalMargin: 10,
                      columnWidthBuilder: (columnIndex) {
                        if (columnIndex case 0) {
                          return const IntrinsicColumnWidth(flex: 1);
                        }
                        return null;
                      },
                      columns: [
                        DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text(
                            'Tên Sản Phẩm'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text(
                            'Số Lượng'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          numeric: true,
                          label: Text(
                            'Đơn Giá'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text(
                            'Thành Tiền'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                          headingRowAlignment: MainAxisAlignment.center,
                          label: Text(
                            'Hành Động'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      rows: [
                        for (final item in orderItems)
                          DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    orderItemProductMap[item.id]?.name ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: BoxWNumberField(
                                      readOnly: readOnly,
                                      initial: item.quantity,
                                      onChanged: (value) {
                                        if (value != null) {
                                          final index =
                                              orderItems.indexOf(item);
                                          tableState(() {
                                            orderItems[index] = item.copyWith(
                                              quantity: value,
                                              totalPrice:
                                                  (value * item.unitSalePrice)
                                                      .toInt(),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${item.unitSalePrice}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${item.totalPrice}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      // TODO: Xoá sản phẩm đã thêm
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        DataRow(
                          cells: [
                            const DataCell(SizedBox.shrink()),
                            const DataCell(SizedBox.shrink()),
                            const DataCell(
                              Center(
                                child: Text(
                                  'Tổng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '$total',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const DataCell(SizedBox.shrink()),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
