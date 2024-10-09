import 'package:sales/data/mappers/get_orders_result_mapper.dart';
import 'package:sales/data/mappers/get_result_mapper_extension.dart';
import 'package:sales/data/mappers/order_item_mapper_extension.dart';
import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/mappers/order_with_items_params_mapper_extension.dart';
import 'package:sales/data/repositories/database.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/order_repository.dart';

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
    return _database.getDailyRevenueForMonth(dateTime);
  }

  @override
  Future<RecentOrdersResult> getThreeRecentOrders() async {
    final result = await _database.getThreeRecentOrders();
    return result.toDomain();
  }

  @override
  Future<void> addOrder(Order order) {
    return _database.addOrder(order.toData());
  }

  @override
  Future<List<OrderItem>> getOrderItems([GetOrderItemsParams? params]) async {
    final orderItems = await _database.getOrderItems(params);
    return orderItems.map((e) => e.toDomain()).toList();
  }

  @override
  Future<GetResult<Order>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    final result = await _database.getOrders(params);
    return result.toDomain();
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
  Future<void> updateOrderWithItems(OrderWithItemsParams<Order, OrderItem> params) {
    return _database.updateOrderWithItems(params.toData());
  }

  @override
  Future<void> addOrderWithItems(OrderWithItemsParams<Order, OrderItem> params) {
    return _database.addOrderWithOrderItems(params.toData());
  }

  @override
  Future<void> removeOrderWithItems(Order order) {
    return _database.removeOrderWithItems(order.toData());
  }
}
