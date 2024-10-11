import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

abstract class ReportRepository {
  Future<int> getDailyOrderCount(DateTime dateTime);
  Future<RecentOrdersResult> getThreeRecentOrders();
  Future<int> getDailyRevenue(DateTime dateTime);
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);
  Future<List<Product>> getFiveLowStockProducts();
  Future<Map<Product, int>> getFiveHighestSalesProducts();
}
