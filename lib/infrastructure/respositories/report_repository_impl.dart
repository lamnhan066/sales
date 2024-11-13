import 'package:sales/data/mappers/get_orders_result_mapper_extension.dart';
import 'package:sales/data/mappers/product_mapper_extension.dart';
import 'package:sales/data/repositories/report_database_repository.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDatabaseRepository _database;

  const ReportRepositoryImpl(this._database);

  @override
  Future<int> getDailyOrderCount(DateTime dateTime) {
    return _database.getDailyOrderCount(dateTime);
  }

  @override
  Future<int> getDailyRevenue(DateTime dateTime) {
    return _database.getDailyRevenue(dateTime);
  }

  @override
  Future<RecentOrdersResult> getThreeRecentOrders() async {
    final result = await _database.getThreeRecentOrders();
    return result.toDomain();
  }

  @override
  Future<Map<Product, int>> getFiveHighestSalesProducts() async {
    final result = await _database.getFiveHighestSalesProducts();
    return result.map((k, v) => MapEntry(k.toDomain(), v));
  }

  @override
  Future<List<Product>> getFiveLowStockProducts() async {
    final result = await _database.getFiveLowStockProducts();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime) {
    return _database.getDailyRevenueForMonth(dateTime);
  }

  @override
  Future<Map<Product, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange) {
    return _database.getSoldProductsWithQuantity(dateRange);
  }

  @override
  Future<int> getRevenuue(Ranges<DateTime> params) {
    return _database.getRevenue(params);
  }

  @override
  Future<int> getProfit(Ranges<DateTime> params) {
    return _database.getProfit(params);
  }
}
