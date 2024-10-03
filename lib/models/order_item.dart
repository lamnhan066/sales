import 'dart:convert';

class OrderItem {
  /// Id.
  final int id;

  /// Số lượng.
  final int quantity;

  /// Đơn giá.
  final double unitSalePrice;

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
      unitSalePrice: (map['unitSalePrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['totalPrice'] as num?)?.toInt() ?? 0,
      productId: (map['productId'] as num?)?.toInt() ?? 0,
      orderId: (map['orderId'] as num?)?.toInt() ?? 0,
      deleted: (map['deleted'] as bool?) ?? false,
    );
  }

  /// SQL Map -> OrderItem.
  factory OrderItem.fromSqlMap(Map<String, dynamic> map) {
    return OrderItem(
      id: (map['oi_id'] as num?)?.toInt() ?? 0,
      quantity: (map['oi_quantity'] as num?)?.toInt() ?? 0,
      unitSalePrice: (map['oi_unit_sale_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['oi_total_price'] as num?)?.toInt() ?? 0,
      productId: (map['oi_productI_i'] as num?)?.toInt() ?? 0,
      orderId: (map['oi_order_id'] as num?)?.toInt() ?? 0,
      deleted: (map['oi_deleted'] as bool?) ?? false,
    );
  }

  /// JSON -> OrderItem.
  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Sao chép.
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

  /// OrderItem -> SQL Map.
  Map<String, dynamic> toSqlMap() {
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
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderItem(id: $id, quantity: $quantity, unitSalePrice: $unitSalePrice, totalPrice: $totalPrice, productId: $productId, orderId: $orderId, deleted: $deleted)';
  }
}
