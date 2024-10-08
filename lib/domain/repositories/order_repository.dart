import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class OrderRepository {
  Future<int> getDailyRevenues(DateTime dateTime);
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<List<int>> getMonthlyRevenues(DateTime dateTime);
  Future<void> removeAllOrdersWithOrderItems();
}
