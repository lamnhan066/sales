import 'package:sales/data/mappers/order_item_mapper_extension.dart';
import 'package:sales/data/repositories/order_item_database.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemDatabase _database;

  const OrderItemRepositoryImpl(this._database);

  @override
  Future<int> getNextOrderItemId() {
    return _database.getNextOrderItemId();
  }

  @override
  Future<List<OrderItem>> getOrderItems([GetOrderItemsParams? params]) async {
    final orderItems = await _database.getOrderItems(params);
    return orderItems.map((e) => e.toDomain()).toList();
  }
}
