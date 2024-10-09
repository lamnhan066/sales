import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

abstract class OrderWithItemsRepository {
  Future<void> addOrderWithItems(OrderWithItemsParams<Order, OrderItem> params);
  Future<void> updateOrderWithItems(OrderWithItemsParams<Order, OrderItem> params);
  Future<void> removeOrderWithItems(Order order);
}
