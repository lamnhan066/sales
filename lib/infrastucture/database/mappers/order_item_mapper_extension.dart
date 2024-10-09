import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/infrastucture/database/models/order_item_model.dart';

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
