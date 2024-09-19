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
}
