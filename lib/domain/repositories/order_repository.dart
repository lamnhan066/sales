import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';

abstract class OrderRepository {
  Future<void> addOrder(Order order);
  Future<GetResult<Order>> getOrders(GetOrderParams params);
  Future<int> getNextOrderId();
}
