import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/order_with_items_model.dart';

abstract interface class OrderWithItemsDatabaseRepository {
  /// Thêm OrderModel cùng với OrderItems
  Future<int> addOrderWithItems(OrderWithItemsParamsModel params);

  /// Cập nhật OrderModel cùng với OrderItems
  Future<void> updateOrderWithItems(OrderWithItemsParamsModel params);

  /// Xoá OrderModel cùng với OrderItems
  Future<void> removeOrderWithItems(OrderModel order);

  /// Thêm tất cả đơn hàng và chi tiết đơn hàng
  Future<void> addAllOrdersWithItems(List<OrderWithItemsParamsModel> orderWithItems);

  /// Lấy tất cả đơn hàng và chi tiết đơn hàng kể cả đơn đã bị xoá
  Future<List<OrderWithItemsParamsModel>> getAllOrdersWithItems();
}
