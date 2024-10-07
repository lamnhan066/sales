// ignore_for_file: function_lines_of_code, cyclomatic_complexity
import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/components/common_dialogs.dart';
import 'package:sales/components/orders/order_form_dialog.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/utils/utils.dart';
import 'package:sales/di.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/order_status.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/range_of_dates.dart';
import 'package:sales/services/database/database.dart';

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
  void onFilterTapped(BuildContext context, SetState setState) {
    // TODO: Thêm hành động khi nhấn nút lọc
  }

  /// Hiển thị thông tin đơn hàng.
  Future<void> infoOrder(
    BuildContext context,
    SetState setState,
    Order order,
  ) async {
    await _infoOrderDialog(context, setState, order);
  }

  /// Thêm đơn hàng
  Future<void> addOrder(
    BuildContext context,
    SetState setState,
  ) async {
    final result = await _addOrderDialog(context, setState);

    if (result != null) {
      await _database.addOrderWithOrderItems(result.order, result.orderItems);
      await _updateCurrentPage(setState);
    }
  }

  /// Chỉnh sửa đơn hàng.
  Future<void> editOrder(
    BuildContext context,
    SetState setState,
    Order order,
  ) async {
    final result = await _editOrderDialog(context, setState, order);

    if (result != null) {
      await _database.updateOrderWithOrderItems(
        result.order,
        result.orderItems,
      );
      await _updateCurrentPage(setState);
    }
  }

  /// Sao chép đơn hàng.
  Future<void> copyOrder(
    BuildContext context,
    SetState setState,
    Order order,
  ) async {
    final result = await _copyOrderDialog(context, setState, order);

    if (result != null) {
      await _database.addOrderWithOrderItems(result.order, result.orderItems);
      await _updateCurrentPage(setState);
    }
  }

  /// Xoá đơn hàng.
  Future<void> removeOrder(
    BuildContext context,
    SetState setState,
    Order order,
  ) async {
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá đơn này không?'.tr,
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await _database.removeOrderWithOrderItems(order);
      await _updateCurrentPage(setState);
    }
  }
}

/// Các hàm private.
extension PrivateOrderController on OrderController {
  Future<({Order order, List<OrderItem> orderItems})?> _infoOrderDialog(
    BuildContext context,
    SetState setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thông Tin Đơn'.tr,
      order: order,
      copy: false,
      readOnly: true,
    );
  }

  Future<({Order order, List<OrderItem> orderItems})?> _addOrderDialog(
      BuildContext context, SetState setState) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Thêm Đơn'.tr,
      order: null,
      copy: true,
    );
  }

  Future<({Order order, List<OrderItem> orderItems})?> _editOrderDialog(
    BuildContext context,
    SetState setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Sửa Đơn'.tr,
      order: order,
      copy: false,
    );
  }

  Future<({Order order, List<OrderItem> orderItems})?> _copyOrderDialog(
    BuildContext context,
    SetState setState,
    Order order,
  ) {
    return _orderDialog(
      context: context,
      setState: setState,
      title: 'Chép Đơn'.tr,
      order: order,
      copy: true,
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

  void _updatePagesCountAndList(int totalCount, List<Order> order) {
    orders = order;

    _totalPage = (totalCount / perpage).floor();
    // Nếu tồn tại số dư thì số trang được cộng thêm 1 vì tôn tại trang có
    // ít hơn `_perpage` sản phẩm.
    if (totalCount % perpage != 0) {
      _totalPage += 1;
    }
  }

  Future<({Order order, List<OrderItem> orderItems})?> _orderDialog({
    required BuildContext context,
    required SetState setState,
    required String title,
    required Order? order,
    required bool copy,
    bool readOnly = false,
  }) async {
    // Đếm id cho orderItem trong quá trình thêm, chỉnh sửa và sao chép đơn hàng.
    int orderItemId = await _database.generateOrderItemId();

    Order tempOrder = order ??
        Order(
          id: 0,
          status: OrderStatus.created,
          date: DateTime.now(),
        );
    final List<OrderItem> orderItems = [];
    var products = await _database.getAllProducts();
    final isNewOrder = order == null || copy;

    if (order != null) {
      orderItems
          .addAll(await _database.getAllOrderItems(orderId: tempOrder.id));
    }

    if (isNewOrder) {
      final id = await _database.generateOrderId();
      tempOrder = tempOrder.copyWith(id: id, date: DateTime.now());
    }

    if (copy) {
      tempOrder = tempOrder.copyWith(status: OrderStatus.created);
      for (int i = 0; i < orderItems.length; i++) {
        orderItems[i] =
            orderItems[i].copyWith(orderId: tempOrder.id, id: orderItemId);
        orderItemId++;
      }
    }

    final form = GlobalKey<FormState>();
    final formValidator = StreamController<bool>();

    void validateForm() {
      formValidator.add(form.currentState?.validate() ?? false);
    }

    /// Điều chỉnh lại `id` của order item để khớp với database, tránh tình
    /// trạng khi xoá orderItem thì `id` sẽ bị lệch.
    Future<void> regenerateOrderItemIds() async {
      orderItemId = await _database.generateOrderItemId();
      for (int i = 0; i < orderItems.length; i++) {
        orderItems[i] = orderItems[i].copyWith(id: orderItemId);
        orderItemId++;
      }
    }

    Future<OrderItem> addProduct(Product product) async {
      final orderItem = OrderItem(
        id: orderItemId,
        quantity: 1,
        unitSalePrice: product.importPrice.toDouble(),
        totalPrice: Utils.calcTotalPrice(
          product.importPrice,
          product.importPrice,
          1,
        ),
        productId: product.id,
        orderId: tempOrder.id,
      );
      orderItemId++;
      orderItems.add(orderItem);

      return orderItem;
    }

    Future<void> statusChanged(OrderStatus status) async {
      tempOrder = tempOrder.copyWith(status: status);
    }

    Future<void> removeProduct(Product product) async {
      if (isNewOrder) {
        orderItems
            .removeWhere((orderItem) => orderItem.productId == product.id);
        await regenerateOrderItemIds();
      } else {
        final index = orderItems.indexWhere((e) => e.productId == product.id);
        orderItems[index] = orderItems[index].copyWith(deleted: true);
      }
    }

    Future<void> quantityChanged(OrderItem item) async {
      final index = orderItems.indexWhere((e) => e.id == item.id);
      orderItems[index] = item;
    }

    if (context.mounted) {
      final dialogWidth =
          MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio;
      final result = await boxWDialog(
        context: context,
        title: title,
        constrains: BoxConstraints(
          minWidth: AppConfigs.dialogMinWidth,
          maxWidth: dialogWidth,
        ),
        content: OrderFormDialog(
          controller: this,
          form: form,
          copy: copy,
          readOnly: readOnly,
          tempOrder: tempOrder,
          orderItems: orderItems,
          products: products,
          validateForm: validateForm,
          addProduct: addProduct,
          removeProduct: removeProduct,
          onStatusChanged: statusChanged,
          onQuantityChanged: quantityChanged,
        ),
        buttons: (context) {
          return [
            confirmCancelButtons(
              context: context,
              enableConfirmStream: readOnly ? null : formValidator.stream,
              confirmText: 'OK'.tr,
              cancelText: 'Huỷ'.tr,
              hideCancel: readOnly,
            )
          ];
        },
      );

      await formValidator.close();

      if (result == true) {
        return (order: tempOrder, orderItems: orderItems);
      }
    }

    return null;
  }
}
