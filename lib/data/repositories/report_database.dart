import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/ranges.dart';

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
  /// Dữ liệu sẽ trả về dưới dạng danh sách doanh thu tính từ đầu tháng đến
  /// ngày hiện tại.
  ///
  /// Ví dự: [100, 200, 0, 200] -> Ngày hiện tại là ngày 4 và doanh thu tương
  /// ứng theo từng ngày là 100, 200, 0 và 200.
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  Future<List<ProductModel>> getFiveLowStockProducts();

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  Future<Map<ProductModel, int>> getFiveHighestSalesProducts();

  /// Lấy sản phẩm đã bán và số lượng bán được trong khoảng thời gian [dateRange].
  Future<Map<ProductModel, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange);

  /// Lấy doanh thu trong khoảng thời gian cụ thể.
  Future<int> getRevenue(Ranges<DateTime> params);

  /// Lấy lợi nhuận.
  Future<int> getProfit(Ranges<DateTime> params);
}
