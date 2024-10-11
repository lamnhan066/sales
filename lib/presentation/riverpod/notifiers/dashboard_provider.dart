import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/usecases/products/get_total_product_count_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_order_count_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_revenue_for_month_usecase.dart';
import 'package:sales/domain/usecases/reports/get_daily_revenues_usecase.dart';
import 'package:sales/domain/usecases/reports/get_five_highest_sales_products_usecase.dart';
import 'package:sales/domain/usecases/reports/get_five_low_stock_products_usecase.dart';
import 'package:sales/domain/usecases/reports/get_three_recent_orders_usecase.dart';
import 'package:sales/presentation/riverpod/states/dashboard_state.dart';

final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    getTotalProductCountUseCase: getIt(),
    getFiveLowStockProductsUseCase: getIt(),
    getFiveHighestSalesProductsUseCase: getIt(),
    getDailyOrderCountUseCase: getIt(),
    getDailyRevenueUseCase: getIt(),
    getThreeRecentOrdersUseCase: getIt(),
    getDailyRevenueForMonthUseCase: getIt(),
  );
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDailyOrderCountUseCase getDailyOrderCountUseCase;
  final GetDailyRevenueUseCase getDailyRevenueUseCase;
  final GetFiveHighestSalesProductsUseCase getFiveHighestSalesProductsUseCase;
  final GetFiveLowStockProductsUseCase getFiveLowStockProductsUseCase;
  final GetDailyRevenueForMonth getDailyRevenueForMonthUseCase;
  final GetThreeRecentOrdersUseCase getThreeRecentOrdersUseCase;
  final GetTotalProductCountUseCase getTotalProductCountUseCase;

  DashboardNotifier({
    required this.getDailyOrderCountUseCase,
    required this.getDailyRevenueUseCase,
    required this.getFiveHighestSalesProductsUseCase,
    required this.getFiveLowStockProductsUseCase,
    required this.getDailyRevenueForMonthUseCase,
    required this.getThreeRecentOrdersUseCase,
    required this.getTotalProductCountUseCase,
  }) : super(DashboardState());

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: '');
    final now = DateTime.now();
    try {
      final totalProductCountFuture = getTotalProductCountUseCase(NoParams());
      final fiveLowStockProductsFuture = getFiveLowStockProductsUseCase(NoParams());
      final fiveHighestSalesProductsFuture = getFiveHighestSalesProductsUseCase(NoParams());
      final dailyOrderCountFuture = getDailyOrderCountUseCase(now);
      final dailyRevenueFuture = getDailyRevenueUseCase(now);
      final threeRecentOrdersFuture = getThreeRecentOrdersUseCase(NoParams());
      final dailyRevenueForMonthFuture = getDailyRevenueForMonthUseCase(now);

      final results = await Future.wait([
        totalProductCountFuture,
        fiveLowStockProductsFuture,
        fiveHighestSalesProductsFuture,
        dailyOrderCountFuture,
        dailyRevenueFuture,
        threeRecentOrdersFuture,
        dailyRevenueForMonthFuture,
      ]);

      state = state.copyWith(
        totalProductCount: results[0] as int,
        fiveLowStockProducts: results[1] as List<Product>,
        fiveHighestSalesProducts: results[2] as Map<Product, int>,
        dailyOrderCount: results[3] as int,
        dailyRevenue: results[4] as int,
        threeRecentOrders: results[5] as RecentOrdersResult,
        dailyRevenueForMonth: results[6] as List<int>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
