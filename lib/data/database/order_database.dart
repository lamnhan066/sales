import 'package:sales/data/models/get_orders_result_model.dart';
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

  /// Lấy số lượng đơn đặt hàng hằng ngày.
  Future<int> getDailyOrderCount(DateTime dateTime);

  /// Lấy danh sách 3 đơn đặt hàng gần đây nhất.
  ///
  /// Trả về danh sách sản phẩm đã đặt hàng và thông tin của đơn đặt hàng.
  Future<RecentOrdersResultModel> getThreeRecentOrders();

  /// Lấy tổng doanh thu hằng ngày.
  Future<int> getDailyRevenue(DateTime dateTime);

  /// Lấy tổng doanh thu tháng theo từng ngày.
  ///
  /// Trả về danh sách doanh thu theo ngày từ ngày 1 đến cuối tháng (hoặc đến
  /// ngày hiện tại đối với tháng hiện tại).
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);
}
