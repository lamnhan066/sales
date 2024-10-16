import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/utils/price_utils.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_result.dart';
import 'package:sales/domain/entities/order_status.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/notifiers/orders_provider.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/order_form_dialog.dart';

Future<void> viewOrderDialog({
  required BuildContext context,
  required OrdersNotifier notifier,
  required Order order,
}) {
  return _orderDialog(
    context: context,
    notifier: notifier,
    title: 'Thông Tin Đơn'.tr,
    order: order,
    copy: false,
    readOnly: true,
  );
}

Future<OrderResult?> addOrderDialog({
  required BuildContext context,
  required OrdersNotifier notifier,
}) {
  return _orderDialog(
    context: context,
    notifier: notifier,
    title: 'Thêm Đơn'.tr,
    order: null,
    copy: true,
  );
}

Future<OrderResult?> updateOrderDialog({
  required BuildContext context,
  required OrdersNotifier notifier,
  required Order order,
}) {
  return _orderDialog(
    context: context,
    notifier: notifier,
    title: 'Sửa Đơn'.tr,
    order: order,
    copy: false,
  );
}

Future<OrderResult?> copyOrderDialog({
  required BuildContext context,
  required OrdersNotifier notifier,
  required Order order,
}) {
  return _orderDialog(
    context: context,
    notifier: notifier,
    title: 'Chép Đơn'.tr,
    order: order,
    copy: true,
  );
}

Future<OrderResult?> _orderDialog({
  required BuildContext context,
  required OrdersNotifier notifier,
  required String title,
  required Order? order,
  required bool copy,
  bool readOnly = false,
}) async {
  // Đếm id cho orderItem trong quá trình thêm, chỉnh sửa và sao chép đơn hàng.
  int orderItemId = await notifier.getNextOrderItemId();
  final temporaryOrderWithItems = await notifier.getTemporaryOrderWithItems();
  final isTemporary = temporaryOrderWithItems != null;

  Order resultOrder = order ??
      temporaryOrderWithItems?.order ??
      Order(
        id: 0,
        status: OrderStatus.created,
        date: DateTime.now(),
      );
  final List<OrderItem> orderItems = [];
  final products = await notifier.getProducts();
  final isNewOrder = order == null || copy;

  if (order != null) {
    orderItems.addAll(await notifier.getOrderItems(resultOrder.id));
  } else if (temporaryOrderWithItems != null) {
    orderItems.addAll(temporaryOrderWithItems.orderItems);
  }

  if (isNewOrder) {
    final id = await notifier.getNextOrderId();
    resultOrder = resultOrder.copyWith(id: id, date: DateTime.now());
  }

  if (copy) {
    resultOrder = resultOrder.copyWith(status: OrderStatus.created);
    for (int i = 0; i < orderItems.length; i++) {
      orderItems[i] = orderItems[i].copyWith(orderId: resultOrder.id, id: orderItemId);
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
    orderItemId = await notifier.getNextOrderItemId();
    for (int i = 0; i < orderItems.length; i++) {
      orderItems[i] = orderItems[i].copyWith(id: orderItemId);
      orderItemId++;
    }
  }

  Future<OrderItem> addProduct(Product product) async {
    const quantity = 1;
    final orderItem = OrderItem(
      id: orderItemId,
      quantity: quantity,
      unitSalePrice: product.unitSalePrice,
      totalPrice: PriceUtils.calcTotalPrice(
        product.importPrice,
        product.unitSalePrice,
        quantity,
      ),
      productId: product.id,
      orderId: resultOrder.id,
    );
    orderItemId++;
    orderItems.add(orderItem);

    return orderItem;
  }

  Future<void> statusChanged(OrderStatus status) async {
    resultOrder = resultOrder.copyWith(status: status);
  }

  Future<void> removeProduct(Product product) async {
    orderItems.removeWhere((orderItem) => orderItem.productId == product.id);
    if (isNewOrder) {
      await regenerateOrderItemIds();
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
        isTemporary: isTemporary,
        readOnly: readOnly,
        tempOrder: resultOrder,
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
      await notifier.removeTemporaryOrderWithItems();
      return OrderResult(order: resultOrder, orderItems: orderItems);
    }

    await notifier.saveTemporaryOrderWithItems(
      OrderWithItemsParams(order: resultOrder, orderItems: orderItems),
    );
  }

  return null;
}
