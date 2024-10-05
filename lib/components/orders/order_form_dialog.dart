// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart'
    hide DataTable, DataRow, DataColumn, DataCell;
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/components/data_table_plus.dart';
import 'package:sales/controllers/order_controller.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/order_status.dart';
import 'package:sales/models/product.dart';
import 'package:sales/utils/utils.dart';

class OrderFormDialog extends StatefulWidget {
  const OrderFormDialog({
    super.key,
    required this.controller,
    required this.form,
    required this.readOnly,
    required this.tempOrder,
    required this.orderItems,
    required this.orderItemProductMap,
    required this.products,
    required this.validateForm,
    required this.addProduct,
    required this.removeProduct,
    required this.onStatusChanged,
    required this.onQuantityChanged,
  });

  final OrderController controller;
  final GlobalKey<FormState> form;
  final bool readOnly;
  final Order tempOrder;
  final List<OrderItem> orderItems;
  final Map<int, Product> orderItemProductMap;
  final List<Product> products;
  final VoidCallback validateForm;
  final Future<OrderItem> Function(Product product) addProduct;
  final Future<void> Function(Product product) removeProduct;
  final Future<void> Function(OrderStatus status) onStatusChanged;
  final Future<void> Function(OrderItem orderItem) onQuantityChanged;

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<OrderFormDialog> {
  List<OrderItem> orderItems = [];
  Map<int, Product> orderItemProductMap = {};
  List<Product> products = [];

  @override
  void initState() {
    orderItems = [...widget.orderItems];
    orderItemProductMap = {...widget.orderItemProductMap};
    products = [...widget.products];
    super.initState();
  }

  void onAddPressed() async {
    Product selected = products.first;
    final result = await boxWDialog(
      context: context,
      title: 'Chọn sản phẩm'.tr,
      width: 300,
      content: SizedBox(
        height: 300,
        child: StatefulBuilder(builder: (context, listViewState) {
          return Material(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: selected == products[index]
                      ? Theme.of(context).primaryColor
                      : null,
                  textColor: selected == products[index]
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
                  title: Text(products[index].name),
                  onTap: () {
                    listViewState(() {
                      selected = products[index];
                    });
                  },
                );
              },
            ),
          );
        }),
      ),
      buttons: (context) {
        return [
          confirmCancelButtons(
            context: context,
            confirmText: 'Thêm'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    if (result == true) {
      final orderItem = await widget.addProduct(selected);

      setState(() {
        orderItems.add(orderItem);
        orderItemProductMap[orderItem.id] = selected;
      });
    }
  }

  void onRemovePressed(int orderItemId, Product product) async {
    await widget.removeProduct(product);
    setState(() {
      orderItems.removeWhere((item) => product.id == item.productId);
    });
    widget.validateForm();
  }

  void onQuantityChanged(int? value, OrderItem orderItem) {
    if (value != null) {
      final index = orderItems.indexOf(orderItem);
      setState(() {
        orderItems[index] = orderItem.copyWith(
          quantity: value,
          totalPrice: (value * orderItem.unitSalePrice).toInt(),
        );
        widget.onQuantityChanged(orderItems[index]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Form(
        key: widget.form,
        onChanged: widget.validateForm,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: BoxWInput(
                    readOnly: true,
                    initial: Utils.formatDateTime(widget.tempOrder.date),
                    title: 'Ngày Giờ'.tr,
                  ),
                ),
                Flexible(
                  child: widget.readOnly
                      ? BoxWInput(
                          readOnly: true,
                          title: 'Trạng thái'.tr,
                          initial: widget.tempOrder.status.text,
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
                          value: widget.tempOrder.status,
                          onChanged: (value) {
                            if (value != null) {
                              widget.onStatusChanged(value);
                            }
                          },
                        ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (_) {
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
                          if (columnIndex == 1) {
                            return const IntrinsicColumnWidth(flex: 1);
                          }
                          return null;
                        },
                        columns: [
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'STT'.tr,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            numeric: true,
                            label: Text(
                              'Đơn Giá'.tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                          if (!widget.readOnly)
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
                                      '${(widget.controller.page - 1) * widget.controller.perpage + orderItems.indexOf(item) + 1}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
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
                                        readOnly: widget.readOnly,
                                        initial: item.quantity,
                                        onChanged: (value) {
                                          onQuantityChanged(value, item);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.unitSalePrice.toInt()}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.totalPrice}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                if (!widget.readOnly)
                                  DataCell(
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          onRemovePressed(
                                            item.id,
                                            widget
                                                .orderItemProductMap[item.id]!,
                                          );
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
                              const DataCell(SizedBox.shrink()),
                              const DataCell(
                                Center(
                                  child: Text(
                                    'Tổng',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '$total',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (!widget.readOnly)
                                const DataCell(SizedBox.shrink()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: onAddPressed,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
