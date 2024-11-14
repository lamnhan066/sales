import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

abstract class OrderWithItemsRepository {
  Future<List<OrderWithItemsParams>> getAllOrdersWithItems();
  Future<void> addAllOrdersWithItems(List<OrderWithItemsParams> orderWithItems);
  Future<int> addOrderWithItems(OrderWithItemsParams params);
  Future<void> updateOrderWithItems(OrderWithItemsParams params);
  Future<void> removeOrderWithItems(Order order);
}
