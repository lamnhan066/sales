import 'package:sales/data/models/order_model.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';

abstract interface class OrderDatabase {
  /// Thêm đơn đặt hàng.
  Future<void> addOrder(OrderModel order);

  /// Cập nhật đơn đặt hàng.
  Future<void> updateOrder(OrderModel order);

  /// Xoá đơn đặt hàng.
  Future<void> removeOrder(OrderModel order);

  /// Lấy danh sách tất cả các đơn hàng.
  Future<List<OrderModel>> getAllOrders();

  /// Lấy danh sách đơn hàng theo điều kiện.
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params]);

  /// Lưu tất cả các đơn đặt đặt hàng.
  Future<void> addAllOrders(List<OrderModel> orders);

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> getNextOrderId();
}
