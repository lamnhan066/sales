import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class ReportRepository {
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<int> getDailyRevenue(DateTime dateTime);

  /// Dữ liệu sẽ trả về dưới dạng danh sách doanh thu tính từ đầu tháng đến
  /// ngày hiện tại.
  ///
  /// Ví dự: [100, 200, 0, 200] -> Ngày hiện tại là ngày 4 và doanh thu tương
  /// ứng theo từng ngày là 100, 200, 0 và 200.
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);
  Future<List<Product>> getFiveLowStockProducts();
  Future<Map<Product, int>> getFiveHighestSalesProducts();
}
