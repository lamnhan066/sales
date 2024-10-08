import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/infrastucture/database/database.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';

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
    return _database.removeAllOrdersWithItems();
  }

  @override
  Future<void> addOrder(Order order) {
    return _database.addOrder(order);
  }

  @override
  Future<List<OrderItem>> getOrderItems([GetOrderItemsParams? params]) {
    return _database.getAllOrderItems(params);
  }

  @override
  Future<({List<Order> orders, int totalCount})> getOrders([GetOrderParams params = const GetOrderParams()]) {
    return _database.getOrders(params);
  }

  @override
  Future<int> getNextOrderId() {
    return _database.getNextOrderId();
  }

  @override
  Future<int> getNextOrderItemId() {
    return _database.getNextOrderItemId();
  }

  @override
  Future<void> updateOrderWithItems(OrderWithItemsParams params) {
    return _database.updateOrderWithItems(params);
  }

  @override
  Future<void> addOrderWithItems(OrderWithItemsParams params) {
    return _database.addOrderWithOrderItems(params);
  }

  @override
  Future<void> removeOrderWithItems(Order order) {
    return _database.removeOrderWithItems(order);
  }
}
