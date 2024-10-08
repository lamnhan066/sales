import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';

class OrderResult {
  final Order order;
  final List<OrderItem> orderItems;

  OrderResult({
    required this.order,
    required this.orderItems,
  });
}
