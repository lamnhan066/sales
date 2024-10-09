import 'dart:convert';

import 'package:sales/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  /// Chi tiết đơn hàng.
  OrderItemModel({
    required super.id,
    required super.quantity,
    required super.unitSalePrice,
    required super.totalPrice,
    required super.productId,
    required super.orderId,
    super.deleted = false,
  });

  /// SQL Map -> OrderItem.
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: (map['oi_id'] as num?)?.toInt() ?? 0,
      quantity: (map['oi_quantity'] as num?)?.toInt() ?? 0,
      unitSalePrice: (map['oi_unit_sale_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['oi_total_price'] as num?)?.toInt() ?? 0,
      productId: (map['oi_product_id'] as num?)?.toInt() ?? 0,
      orderId: (map['oi_order_id'] as num?)?.toInt() ?? 0,
      deleted: (map['oi_deleted'] as bool?) ?? false,
    );
  }

  /// JSON -> OrderItem.
  factory OrderItemModel.fromJson(String source) => OrderItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  @override
  OrderItemModel copyWith({
    int? id,
    int? quantity,
    double? unitSalePrice,
    int? totalPrice,
    int? productId,
    int? orderId,
    bool? deleted,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      unitSalePrice: unitSalePrice ?? this.unitSalePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      deleted: deleted ?? this.deleted,
    );
  }

  /// OrderItem -> SQL Map.
  @override
  Map<String, dynamic> toMap() {
    return {
      'oi_id': id,
      'oi_quantity': quantity,
      'oi_unit_sale_price': unitSalePrice,
      'oi_total_price': totalPrice,
      'oi_product_id': productId,
      'oi_order_id': orderId,
      'oi_deleted': deleted,
    };
  }

  /// OrderItem  -> JSON
  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderItem(id: $id, quantity: $quantity, unitSalePrice: $unitSalePrice, totalPrice: $totalPrice, productId: $productId, orderId: $orderId, deleted: $deleted)';
  }
}
