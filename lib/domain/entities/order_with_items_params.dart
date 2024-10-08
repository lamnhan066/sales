import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';

class OrderWithItemsParams {
  final Order order;
  final List<OrderItem> orderItems;

  OrderWithItemsParams({
    required this.order,
    required this.orderItems,
  });
}
