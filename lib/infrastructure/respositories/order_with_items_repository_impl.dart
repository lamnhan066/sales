import 'package:sales/data/database/order_with_items_database.dart';
import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/mappers/order_with_items_params_mapper_extension.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class OrderWithItemsRepositoryImpl implements OrderWithItemsRepository {
  final OrderWithItemsDatabase _database;

  OrderWithItemsRepositoryImpl(this._database);

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
