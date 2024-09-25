import 'dart:convert';

class OrderItem {
  final int id;
  final int quantity;
  final double unitSalePrice;
  final int totalPrice;
  final int productId;
  final int orderId;
  final bool deleted;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.unitSalePrice,
    required this.totalPrice,
    required this.productId,
    required this.orderId,
    this.deleted = true,
  });

  OrderItem copyWith({
    int? id,
    int? quantity,
    double? unitSalePrice,
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

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      unitSalePrice: map['unitSalePrice']?.toDouble() ?? 0.0,
      totalPrice: map['totalPrice']?.toInt() ?? 0,
      productId: map['productId']?.toInt() ?? 0,
      orderId: map['orderId']?.toInt() ?? 0,
      deleted: map['deleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}
