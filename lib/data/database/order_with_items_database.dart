import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

abstract interface class OrderWithItemsDatabase {
  /// Thêm OrderModel cùng với OrderItems
  Future<void> addOrderWithOrderItems(OrderWithItemsParams<OrderModel, OrderItemModel> params);

  /// Cập nhật OrderModel cùng với OrderItems
  Future<void> updateOrderWithItems(OrderWithItemsParams<OrderModel, OrderItemModel> params);

  /// Xoá OrderModel cùng với OrderItems
  Future<void> removeOrderWithItems(OrderModel order);
}
