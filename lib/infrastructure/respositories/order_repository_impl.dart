import 'package:sales/data/mappers/get_result_mapper_extension.dart';
import 'package:sales/data/mappers/order_mapper_extension.dart';
import 'package:sales/data/repositories/order_database.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDatabase _database;

  const OrderRepositoryImpl(this._database);

  @override
  Future<void> addOrder(Order order) {
    return _database.addOrder(order.toData());
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
}
