import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';

abstract interface class OrderItemDatabase {
  /// Thêm chi tiết sản phẩm đã đặt hàng.
  Future<void> addOrderItem(OrderItemModel orderItem);

  /// Cập nhật chi tiết sản phẩm đã đặt hàng.
  Future<void> updateOrderItem(OrderItemModel orderItem);

  /// Xoá chi tiết sản phẩm đã đặt hàng.
  Future<void> removeOrderItem(OrderItemModel orderItem);

  /// Lấy danh sách chi tiết sản phẩm đã đặt theo mã đơn và mã sản phẩm.
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params]);

  /// Lấy tất tất cả chi tiết đơn đặt hàng kể cả chi tiết đơn đã bị xoá.
  Future<List<OrderItemModel>> getAllOrderItems();

  /// Lưu tất cả sản phẩm đã đặt hàng kể cả đơn đã xoá.
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems);

  /// Trình tạo ra `id` cho chi tiết đơn hàng.
  Future<int> getNextOrderItemId();
}
