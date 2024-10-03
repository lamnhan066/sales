import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/app/app_configs.dart';
import 'package:sales/components/common_dialogs.dart';
import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/order_status.dart';
import 'package:sales/models/range_of_dates.dart';
import 'package:sales/services/database/database.dart';
import 'package:sales/utils/utils.dart';

/// Controller cho màn hình Order.
class OrderController {
  final _database = getIt<Database>();

  /// Danh sách đơn hàng.
  List<Order> orders = [];

  /// Số đơn hàng mỗi trang.
  final int perpage = 10;

  /// Vị trí trang hiện tại.
  int page = 1;

  int _totalPage = 0;

  /// Khoảng ngày khi lọc.
  RangeOfDates? dateRange;

  /// Tổng số trang.
  int get totalPage => _totalPage;

  /// Khởi tạo.
  Future<void> initial(SetState setState) async {
    await _database.getOrders().then((value) {
      setState(() {
        _updatePagesCountAndList(value.totalCount, value.orders);
      });
    });
  }

  /// Callback khi nhấn nút trở về trang trước.
  Future<void> onPagePrevious(SetState setState) async {
    if (page <= 1) return;
    await _changePage(setState, page - 1);
  }

  /// Callback khi nhấn nút sang trang kế.
  Future<void> onPageNext(SetState setState) async {
    if (page >= totalPage) return;
    await _changePage(setState, page + 1);
  }

  /// Callback khi có sự thay đổi trang bằng tay.
  Future<void> onPageChanged(
    BuildContext context,
    SetState setState,
  ) async {
    final newPage =
        await pageChooser(context: context, page: page, totalPage: totalPage);

    if (newPage != null) {
      page = newPage;
      await _changePage(setState, page);
    }
  }

  /// Nhấn nút lọc.
  void onFilterTapped(
    BuildContext context,
    SetState setState,
  ) {}

  /// Hiển thị thông tin đơn hàng.
  Future<void> infoOrder(
    BuildContext context,
    SetState setState,
    Order o,
  ) async {
    await _infoOrderDialog(context, setState, o);
  }

  /// Thêm đơn hàng
  Future<void> addOrder(
    BuildContext context,
    SetState setState,
  ) async {
    final order = await _addOrderDialog(context, setState);

    if (order != null) {
      await _database.addOrder(order);
      await _updateCurrentPage(setState);
    }
  }

  /// Chỉnh sửa đơn hàng.
  Future<void> editOrder(
    BuildContext context,
    SetState setState,
    Order o,
  ) async {
    final order = await _editOrderDialog(context, setState, o);

    if (order != null) {
      await _database.updateOrder(order);
      await _updateCurrentPage(setState);
    }
  }

  /// Sao chép đơn hàng.
  Future<void> copyOrder(
    BuildContext context,
    SetState setState,
    Order o,
  ) async {
    final order = await _copyOrderDialog(context, setState, o);

    if (order != null) {
      await _database.addOrder(order);
      await _updateCurrentPage(setState);
    }
  }

  /// Xoá đơn hàng.
  Future<void> removeOrder(
    BuildContext context,
    SetState setState,
    Order o,
  ) async {
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá đơn này không?'.tr,
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await _database.removeOrder(o);
      await _updateCurrentPage(setState);
    }
  }
}

/// Các hàm private.
extension PrivateOrderController on OrderController {
  Future<Order?> _infoOrderDialog(
    BuildContext context,
    Function setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thông Tin Đơn'.tr,
      order: order,
      generateId: false,
      readOnly: true,
    );
  }

  Future<Order?> _addOrderDialog(BuildContext context, Function setState) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thêm Đơn'.tr,
      order: null,
      generateId: true,
    );
  }

  Future<Order?> _editOrderDialog(
    BuildContext context,
    Function setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Sửa Đơn'.tr,
      order: order,
      generateId: false,
    );
  }

  Future<Order?> _copyOrderDialog(
    BuildContext context,
    Function setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Chép Đơn'.tr,
      order: order,
      generateId: true,
    );
  }

  Future<void> _changePage(
    SetState setState,
    int newPage,
  ) async {
    page = newPage;
    await _updateCurrentPage(setState);
  }

  Future<void> _updateCurrentPage(
    SetState setState, {
    bool resetPage = false,
  }) async {
    if (resetPage) page = 1;

    final allOrders = await _database.getOrders(
      page: page,
      perpage: perpage,
      dateRange: dateRange,
    );

    setState(() {
      _updatePagesCountAndList(allOrders.totalCount, allOrders.orders);
    });
  }

  void _updatePagesCountAndList(int totalCount, List<Order> o) {
    orders = o;

    _totalPage = (totalCount / perpage).floor();
    // Nếu tồn tại số dư thì số trang được cộng thêm 1 vì tôn tại trang có
    // ít hơn `_perpage` sản phẩm.
    if (totalCount % perpage != 0) {
      _totalPage += 1;
    }
  }

  Future<Order?> _orderDialog({
    required BuildContext context,
    required Function setState,
    required String title,
    required Order? order,
    required bool generateId,
    bool readOnly = false,
  }) async {
    Order tempOrder = order ??
        Order(
          id: 0,
          status: OrderStatus.created,
          date: DateTime.now(),
        );
    if (generateId || order == null) {
      final id = await _database.generateCategoryId();
      tempOrder = tempOrder.copyWith(id: id);
    }

    final form = GlobalKey<FormState>();
    final formValidator = StreamController<bool>();

    final List<OrderItem> orderItems = await _database.getOrderItems(
      orderId: tempOrder.id,
    );

    final products = await _database.getAllProducts();

    void validateForm() {
      formValidator.add(form.currentState?.validate() ?? false);
    }

    if (context.mounted) {
      final dialogWidth =
          MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio;
      final result = await boxWDialog(
        context: context,
        title: title,
        width: dialogWidth,
        constrains: BoxConstraints(
          minWidth: AppConfigs.dialogMinWidth,
          maxWidth: dialogWidth,
        ),
        content: Form(
          key: form,
          onChanged: validateForm,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: BoxWInput(
                      readOnly: readOnly,
                      initial: Utils.formatDateTime(tempOrder.date),
                      title: 'Ngày Giờ'.tr,
                    ),
                  ),
                  Flexible(
                    child: BoxWDropdown(
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
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            'Tên Sản Phẩm',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Số Lượng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Đơn Giá',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Thành Tiền',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    for (final item in orderItems)
                      Builder(
                        builder: (_) {
                          final product = products
                              .firstWhere((e) => e.id == item.productId);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text(
                                  product.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '${item.quantity}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '${item.unitSalePrice}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '${item.totalPrice}',
                                  textAlign: TextAlign.center,
                                ),
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
        ),
        buttons: (context) {
          return [
            Buttons(
              axis: Axis.horizontal,
              buttons: [
                StreamBuilder<bool>(
                  stream: formValidator.stream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: FilledButton(
                        onPressed: !snapshot.hasData || snapshot.data != true
                            ? null
                            : () {
                                Navigator.pop(context, true);
                              },
                        child: Text('OK'.tr),
                      ),
                    );
                  },
                ),
                if (!readOnly)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Huỷ'.tr),
                    ),
                  ),
              ],
            ),
          ];
        },
      );

      await formValidator.close();

      if (result == true) {
        return tempOrder;
      }
    }

    return null;
  }
}
