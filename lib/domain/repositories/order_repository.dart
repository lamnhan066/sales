import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';

abstract class OrderRepository {
  Future<int> getDailyRevenues(DateTime dateTime);
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<List<int>> getMonthlyRevenues(DateTime dateTime);
  Future<void> removeAllOrdersWithOrderItems();
  Future<void> addOrder(Order order);
  Future<({int totalCount, List<Order> orders})> getOrders(GetOrderParams params);
  Future<List<OrderItem>> getOrderItems(GetOrderItemsParams params);
  Future<int> getNextOrderId();
  Future<int> getNextOrderItemId();
  Future<void> updateOrderWithItems(OrderWithItemsParams params);
  Future<void> addOrderWithItems(OrderWithItemsParams params);
  Future<void> removeOrderWithItems(Order order);
}
