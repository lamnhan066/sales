class OrderItem {
  final int id;
  final int quantity;
  final double unitSalePrice;
  final int totalPrice;
  final int productId;
  final int orderId;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.unitSalePrice,
    required this.totalPrice,
    required this.productId,
    required this.orderId,
  });
}
