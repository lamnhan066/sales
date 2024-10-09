import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class OrderRepository {
  Future<int> getDailyRevenues(DateTime dateTime);
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<List<int>> getMonthlyRevenues(DateTime dateTime);
  Future<void> addOrder(Order order);
  Future<GetResult<Order>> getOrders(GetOrderParams params);
  Future<List<OrderItem>> getOrderItems(GetOrderItemsParams params);
  Future<int> getNextOrderId();
  Future<int> getNextOrderItemId();
  Future<void> updateOrderWithItems(OrderWithItemsParams<Order, OrderItem> params);
  Future<void> addOrderWithItems(OrderWithItemsParams<Order, OrderItem> params);
  Future<void> removeOrderWithItems(Order order);
}
