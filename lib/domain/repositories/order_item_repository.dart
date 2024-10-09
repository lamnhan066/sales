import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/order_item.dart';

abstract class OrderItemRepository {
  Future<List<OrderItem>> getOrderItems(GetOrderItemsParams params);
  Future<int> getNextOrderItemId();
}
