import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/utils/utils.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_result.dart';
import 'package:sales/domain/entities/order_status.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/widgets/order_form_dialog.dart';

Future<void> viewOrderDialog({
  required BuildContext context,
  required Order order,
  required Future<List<Product>> Function() getProducts,
  required Future<int> Function() nextOrderItemId,
  required Future<int> Function() nextOrderId,
  required Future<List<OrderItem>> Function(int orderId) getOrderItems,
}) {
  return _orderDialog(
    context: context,
    title: 'Thông Tin Đơn'.tr,
    order: order,
    copy: false,
    readOnly: true,
    getNextOrderItemId: nextOrderItemId,
    getNextOrderId: nextOrderId,
    getOrderItems: getOrderItems,
    getProducts: getProducts,
  );
}

Future<OrderResult?> addOrderDialog({
  required BuildContext context,
  required Future<List<Product>> Function() getProducts,
  required Future<int> Function() nextOrderItemId,
  required Future<int> Function() nextOrderId,
  required Future<List<OrderItem>> Function(int orderId) getOrderItems,
}) {
  return _orderDialog(
    context: context,
    title: 'Thêm Đơn'.tr,
    order: null,
    copy: true,
    getNextOrderItemId: nextOrderItemId,
    getNextOrderId: nextOrderId,
    getOrderItems: getOrderItems,
    getProducts: getProducts,
  );
}

Future<OrderResult?> updateOrderDialog({
  required BuildContext context,
  required Future<List<Product>> Function() getProducts,
  required Order order,
  required Future<int> Function() nextOrderItemId,
  required Future<int> Function() nextOrderId,
  required Future<List<OrderItem>> Function(int orderId) getOrderItems,
}) {
  return _orderDialog(
    context: context,
    title: 'Sửa Đơn'.tr,
    order: order,
    copy: false,
    getNextOrderItemId: nextOrderItemId,
    getNextOrderId: nextOrderId,
    getOrderItems: getOrderItems,
    getProducts: getProducts,
  );
}

Future<OrderResult?> copyOrderDialog({
  required BuildContext context,
  required Future<List<Product>> Function() getProducts,
  required Order order,
  required Future<int> Function() nextOrderItemId,
  required Future<int> Function() nextOrderId,
  required Future<List<OrderItem>> Function(int orderId) getOrderItems,
}) {
  return _orderDialog(
    context: context,
    title: 'Chép Đơn'.tr,
    order: order,
    copy: true,
    getProducts: getProducts,
    getNextOrderItemId: nextOrderItemId,
    getNextOrderId: nextOrderId,
    getOrderItems: getOrderItems,
  );
}

Future<OrderResult?> _orderDialog({
  required BuildContext context,
  required Future<List<Product>> Function() getProducts,
  required String title,
  required Order? order,
  required bool copy,
  required Future<int> Function() getNextOrderItemId,
  required Future<int> Function() getNextOrderId,
  required Future<List<OrderItem>> Function(int orderId) getOrderItems,
  bool readOnly = false,
}) async {
  // Đếm id cho orderItem trong quá trình thêm, chỉnh sửa và sao chép đơn hàng.
  int orderItemId = await getNextOrderItemId();

  Order tempOrder = order ??
      Order(
        id: 0,
        status: OrderStatus.created,
        date: DateTime.now(),
      );
  final List<OrderItem> orderItems = [];
  final products = await getProducts();
  final isNewOrder = order == null || copy;

  if (order != null) {
    orderItems.addAll(await getOrderItems(tempOrder.id));
  }

  if (isNewOrder) {
    final id = await getNextOrderId();
    tempOrder = tempOrder.copyWith(id: id, date: DateTime.now());
  }

  if (copy) {
    tempOrder = tempOrder.copyWith(status: OrderStatus.created);
    for (int i = 0; i < orderItems.length; i++) {
      orderItems[i] = orderItems[i].copyWith(orderId: tempOrder.id, id: orderItemId);
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
    orderItemId = await getNextOrderItemId();
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
      orderItems.removeWhere((orderItem) => orderItem.productId == product.id);
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
    final dialogWidth = MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio;
    final result = await boxWDialog(
      context: context,
      title: title,
      constrains: BoxConstraints(
        minWidth: AppConfigs.dialogMinWidth,
        maxWidth: dialogWidth,
      ),
      content: OrderFormDialog(
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
      return OrderResult(order: tempOrder, orderItems: orderItems);
    }
  }

  return null;
}
