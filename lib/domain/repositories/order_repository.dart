import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class OrderRepository {
  Future<void> addOrder(Order order);
  Future<GetResult<Order>> getOrders(GetOrderParams params);
  Future<int> getNextOrderId();
  Future<int> getDailyRevenues(DateTime dateTime);
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<List<int>> getMonthlyRevenues(DateTime dateTime);
}
