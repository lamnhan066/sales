import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrderItem with EquatableMixin {
  /// Id.
  final int id;

  /// Số lượng.
  final int quantity;

  /// Đơn giá.
  final int unitSalePrice;

  /// Thành tiền.
  final int totalPrice;

  /// Id của Product.
  final int productId;

  /// Id của Order.
  final int orderId;

  /// Đánh dấu xoá.
  final bool deleted;

  /// Chi tiết đơn hàng.
  OrderItem({
    required this.id,
    required this.quantity,
    required this.unitSalePrice,
    required this.totalPrice,
    required this.productId,
    required this.orderId,
    this.deleted = false,
  });

  /// Map -> OrderItem.
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: (map['id'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      unitSalePrice: (map['unitSalePrice'] as num?)?.toInt() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toInt() ?? 0,
      productId: (map['productId'] as num?)?.toInt() ?? 0,
      orderId: (map['orderId'] as num?)?.toInt() ?? 0,
      deleted: (map['deleted'] as bool?) ?? false,
    );
  }

  /// JSON -> OrderItem.
  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
  OrderItem copyWith({
    int? id,
    int? quantity,
    int? unitSalePrice,
    int? totalPrice,
    int? productId,
    int? orderId,
    bool? deleted,
  }) {
    return OrderItem(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      unitSalePrice: unitSalePrice ?? this.unitSalePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      deleted: deleted ?? this.deleted,
    );
  }

  /// OrderItem -> Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'unitSalePrice': unitSalePrice,
      'totalPrice': totalPrice,
      'productId': productId,
      'orderId': orderId,
      'deleted': deleted,
    };
  }

  /// OrderItem  -> JSON
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderItem(id: $id, quantity: $quantity, unitSalePrice: $unitSalePrice, totalPrice: $totalPrice, productId: $productId, orderId: $orderId, deleted: $deleted)';
  }

  @override
  List<Object> get props {
    return [
      id,
      quantity,
      unitSalePrice,
      totalPrice,
      productId,
      orderId,
      deleted,
    ];
  }
}
