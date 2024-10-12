import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class ReportRepository {
  /// Tổng số đơn hàng trong ngày.
  Future<int> getDailyOrderCount(DateTime dateTime);

  /// Thông tin ba đơn hàng gần đây nhất.
  Future<RecentOrdersResult> getThreeRecentOrders();

  /// Tổng doanh thu hằng ngày.
  Future<int> getDailyRevenue(DateTime dateTime);

  /// Dữ liệu sẽ trả về dưới dạng danh sách doanh thu tính từ đầu tháng đến
  /// ngày hiện tại.
  ///
  /// Ví dự: [100, 200, 0, 200] -> Ngày hiện tại là ngày 4 và doanh thu tương
  /// ứng theo từng ngày là 100, 200, 0 và 200.
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);
  Future<List<Product>> getFiveLowStockProducts();

  /// Lấy thông tin 5 sản phẩm bán chạy nhất và số lượng bán được.
  Future<Map<Product, int>> getFiveHighestSalesProducts();

  /// Lấy sản phẩm đã bán và số lượng bán được trong khoảng thời gian [dateRange].
  Future<Map<Product, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange);
}
