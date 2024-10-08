import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/infrastucture/database/database.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Database _database;

  const OrderRepositoryImpl(this._database);

  @override
  Future<int> getDailyOrderCount(DateTime dateTime) {
    return _database.getDailyOrderCount(dateTime);
  }

  @override
  Future<int> getDailyRevenues(DateTime dateTime) {
    return _database.getDailyRevenue(dateTime);
  }

  @override
  Future<List<int>> getMonthlyRevenues(DateTime dateTime) {
    return _database.getMonthlyRevenues(dateTime);
  }

  @override
  Future<RecentOrdersResult> getThreeRecentOrders() {
    return _database.getThreeRecentOrders();
  }

  @override
  Future<void> removeAllOrdersWithOrderItems() {
    return _database.removeAllOrdersWithOrderItems();
  }
}
