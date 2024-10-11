import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/product_model.dart';

abstract interface class ReportDatabase {
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

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  Future<List<ProductModel>> getFiveLowStockProducts();

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  Future<Map<ProductModel, int>> getFiveHighestSalesProducts();
}
