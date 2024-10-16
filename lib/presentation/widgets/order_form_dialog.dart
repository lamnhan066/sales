// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart' hide DataTable, DataRow, DataColumn, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/utils/date_time_utils.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_status.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/notifiers/orders_provider.dart';
import 'package:sales/presentation/views/products_view.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';

class OrderFormDialog extends StatefulWidget {
  const OrderFormDialog({
    super.key,
    required this.form,
    required this.copy,
    required this.isTemporary,
    required this.readOnly,
    required this.tempOrder,
    required this.orderItems,
    required this.products,
    required this.validateForm,
    required this.addProduct,
    required this.removeProduct,
    required this.onStatusChanged,
    required this.onQuantityChanged,
  });

  final GlobalKey<FormState> form;
  final bool copy;
  final bool isTemporary;
  final bool readOnly;
  final Order tempOrder;
  final List<OrderItem> orderItems;
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
  /// Danh sách chi tiết các sản phẩm.
  List<OrderItem> orderItems = [];

  /// Số lượng tối đa tương ứng với từng sản phẩm.
  ///
  /// Đối với sản phẩm đã có trong giỏ hàng thì số lượng tối đa này sẽ là tổng
  /// của số lượng sản phẩm trong kho và số lượng sản phẩm có trong giỏ hàng.
  /// Ngược lại, khi sản phẩm không có sẵn trong giỏ hàng thì giá trị tối đa
  /// sẽ là số lượng sản phẩm có trong kho. Giá trị này chỉ tính một lần duy nhất
  /// khi mục này được mở.
  Map<int, int> maxProductQuantity = {};

  /// Danh sách sản phẩm có thể chọn cho đơn hàng hiện tại.
  ///
  /// Danh sách này sẽ không bao gồm sản phẩm có số lượng bằng 0 và sản phẩm
  /// đã thêm vào trong giỏ hàng.
  List<Product> availableProducts = [];

  bool isNotEnoughQuantityInStock = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    orderItems = [...widget.orderItems];
    for (final product in widget.products) {
      if (widget.isTemporary) {
        maxProductQuantity[product.id] = product.count;
      } else {
        final index = orderItems.indexWhere((e) => e.productId == product.id);
        final isOrderedProduct = index != -1;
        if (isOrderedProduct) {
          isNotEnoughQuantityInStock = widget.copy && orderItems[index].quantity > product.count;

          maxProductQuantity[product.id] = product.count + orderItems[index].quantity;
        } else {
          maxProductQuantity[product.id] = product.count;
        }
      }
    }
    removeExistedAndOutOfStockProducts();
  }

  void onAddPressed() async {
    final size = MediaQuery.sizeOf(context);
    final selected = await boxWDialog(
      context: context,
      showCloseButton: true,
      constrains: BoxConstraints(maxWidth: size.width - 50, maxHeight: size.height - 50),
      width: double.infinity,
      height: double.infinity,
      title: 'Chọn Sản Phẩm'.tr,
      content: const Flexible(
        child: ProductsView(
          chooseProduct: true,
        ),
      ),
    );

    if (selected != null) {
      final orderItem = await widget.addProduct(selected);

      setState(() {
        orderItems.add(orderItem);
        removeExistedAndOutOfStockProducts();
      });

      widget.validateForm();
    }
  }

  void onRemovePressed(int orderItemId, Product product) async {
    await widget.removeProduct(product);
    setState(() {
      orderItems.removeWhere((item) => product.id == item.productId);
      removeExistedAndOutOfStockProducts();
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
      widget.validateForm();
    }
  }

  void removeExistedAndOutOfStockProducts() {
    availableProducts = [...widget.products];
    availableProducts.removeWhere((product) {
      if (product.count <= 0) return true;
      for (final orderItem in orderItems) {
        if (orderItem.productId == product.id) return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isNotEnoughQuantityInStock
        ? Text(
            'Có sản phẩm không đủ số lượng trong kho nên không thể Sao chép.\n'
                    'Vui lòng cập nhật thêm sản phẩm để tiếp tục!'
                .tr,
          )
        : StatefulBuilder(
            builder: (context, setState) {
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
                            initial: DateTimeUtils.formatDateTime(widget.tempOrder.date),
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
                              return SingleChildScrollView(
                                child: DataTable(
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
                                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                                              child: Consumer(builder: (context, ref, child) {
                                                final ordersState = ref.watch(ordersProvider);
                                                return Text(
                                                  '${(ordersState.page - 1) * ordersState.perPage + orderItems.indexOf(item) + 1}',
                                                  textAlign: TextAlign.center,
                                                );
                                              }),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                widget.products.byId(item.productId).name,
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
                                                  min: 1,
                                                  max: maxProductQuantity[item.productId]!,
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
                                                      widget.products.byId(item.productId),
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
                                        if (!widget.readOnly)
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: FilledButton(
                                                onPressed: availableProducts.isEmpty ? null : onAddPressed,
                                                child: const Icon(Icons.add),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
