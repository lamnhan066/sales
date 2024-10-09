import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/domain/entities/order_item.dart';

extension OrderItemModelExtension on OrderItemModel {
  OrderItem toDomain() {
    return OrderItem(
      id: id,
      quantity: quantity,
      unitSalePrice: unitSalePrice,
      totalPrice: totalPrice,
      productId: productId,
      orderId: orderId,
    );
  }
}

extension OrderItemEntityExtension on OrderItem {
  OrderItemModel toData() {
    return OrderItemModel(
      id: id,
      quantity: quantity,
      unitSalePrice: unitSalePrice,
      totalPrice: totalPrice,
      productId: productId,
      orderId: orderId,
    );
  }
}
