// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart' hide DataCell, DataColumn, DataRow, DataTable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/extensions/price_extensions.dart';
import 'package:sales/core/utils/date_time_utils.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_status.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/notifiers/orders_provider.dart';
import 'package:sales/presentation/views/products_view.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';

class OrderFormDialog extends StatefulWidget {
  const OrderFormDialog({
    required this.form,
    required this.copy,
    required this.isTemporary,
    required this.readOnly,
    required this.tempOrder,
    required this.orderItems,
    required this.products,
    required this.discounts,
    required this.validateForm,
    required this.addProduct,
    required this.removeProduct,
    required this.onStatusChanged,
    required this.onQuantityChanged,
    required this.getDiscountByCode,
    required this.onDiscountsChanged,
    super.key,
  });

  final GlobalKey<FormState> form;
  final bool copy;
  final bool isTemporary;
  final bool readOnly;
  final Order tempOrder;
  final List<OrderItem> orderItems;
  final List<Product> products;
  final List<Discount> discounts;
  final VoidCallback validateForm;
  final Future<OrderItem> Function(Product product) addProduct;
  final Future<void> Function(Product product) removeProduct;
  final Future<void> Function(OrderStatus status) onStatusChanged;
  final Future<void> Function(OrderItem orderItem) onQuantityChanged;
  final Future<Discount?> Function(String code) getDiscountByCode;
  final void Function(List<Discount> values) onDiscountsChanged;

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

  String discountCode = '';
  Discount? discount;
  String? discountError;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    // TODO(lamnhan066): Hiện tại chỉ hỗ trợ hiển thị 1 mã giảm giá trên mỗi đơn
    discount = widget.discounts.isEmpty ? null : widget.discounts.first;
    discountCode = discount?.code ?? '';

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

  Future<void> onAddPressed() async {
    final size = MediaQuery.sizeOf(context);
    final selected = await boxWDialog<Product>(
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

  Future<void> onRemovePressed(int orderItemId, Product product) async {
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
          totalPrice: value * orderItem.unitSalePrice,
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

  Future<void> checkDiscountCode() async {
    final temp = await widget.getDiscountByCode(discountCode);
    setState(() {
      discount = temp;
    });
    if (temp == null) {
      discountError = 'Mã đã nhập không tồn tại hoặc đã được sử dụng'.tr;
      widget.onDiscountsChanged([]);
    } else {
      discountError = null;
      widget.onDiscountsChanged([discount!]);
    }
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
                              var total = 0;
                              for (final order in orderItems) {
                                total += order.totalPrice;
                              }
                              if (discount != null) {
                                total = discount!.calculate(total);
                              }
                              return SingleChildScrollView(
                                child: DataTable(
                                  dataRowMinHeight: 68,
                                  dataRowMaxHeight: 68,
                                  columnSpacing: 20,
                                  horizontalMargin: 10,
                                  columns: [
                                    DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text(
                                        'STT'.tr,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IntrinsicDataColumn(
                                      flex: 1,
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
                                              child: Consumer(
                                                builder: (context, ref, child) {
                                                  final ordersState = ref.watch(ordersProvider);
                                                  return Text(
                                                    '${(ordersState.page - 1) * ordersState.perPage + orderItems.indexOf(item) + 1}',
                                                    textAlign: TextAlign.center,
                                                  );
                                                },
                                              ),
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
                                              item.unitSalePrice.toPriceDigit(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              item.totalPrice.toPriceDigit(),
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
                                        DataCell.empty,
                                        DataCell.empty,
                                        DataCell.empty,
                                        DataCell(
                                          Center(
                                            child: Text(
                                              (discount?.hasMaxPrice ?? false)
                                                  ? '${'Giảm giá'.tr}\n${'Tối đa'.tr}'
                                                  : 'Giảm giá'.tr,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              (discount?.hasMaxPrice ?? false)
                                                  ? '${discount?.percent ?? 0}%\n${discount?.maxPrice.toPriceDigit()}'
                                                  : '${discount?.percent ?? 0}%',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        if (!widget.readOnly) DataCell.empty,
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell.empty,
                                        DataCell.empty,
                                        DataCell.empty,
                                        DataCell(
                                          Center(
                                            child: Text(
                                              'Tổng'.tr,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            total.toPriceDigit(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: BoxWInput(
                            enabled: !widget.readOnly,
                            readOnly: widget.readOnly,
                            title: 'Mã Giảm Giá'.tr,
                            initial: discount?.code,
                            validator: (_) => discountError,
                            onChanged: (value) {
                              setState(() {
                                discountError = null;
                                discountCode = value;
                              });
                            },
                          ),
                        ),
                        if (!widget.readOnly)
                          Builder(
                            builder: (context) {
                              final isValidDiscount =
                                  discountError == null && discount != null && discountCode == discount?.code;
                              return FilledButton(
                                onPressed: discountCode.length == 6 && !isValidDiscount ? checkDiscountCode : null,
                                child: Text('Kiểm Tra'.tr),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }
}
