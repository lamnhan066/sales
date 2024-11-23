import 'package:features_tour/features_tour.dart';
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
  DashboardNotifier({
    required GetDailyOrderCountUseCase getDailyOrderCountUseCase,
    required GetDailyRevenueUseCase getDailyRevenueUseCase,
    required GetFiveHighestSalesProductsUseCase getFiveHighestSalesProductsUseCase,
    required GetFiveLowStockProductsUseCase getFiveLowStockProductsUseCase,
    required GetDailyRevenueForMonth getDailyRevenueForMonthUseCase,
    required GetThreeRecentOrdersUseCase getThreeRecentOrdersUseCase,
    required GetTotalProductCountUseCase getTotalProductCountUseCase,
  })  : _getTotalProductCountUseCase = getTotalProductCountUseCase,
        _getThreeRecentOrdersUseCase = getThreeRecentOrdersUseCase,
        _getDailyRevenueForMonthUseCase = getDailyRevenueForMonthUseCase,
        _getFiveLowStockProductsUseCase = getFiveLowStockProductsUseCase,
        _getFiveHighestSalesProductsUseCase = getFiveHighestSalesProductsUseCase,
        _getDailyRevenueUseCase = getDailyRevenueUseCase,
        _getDailyOrderCountUseCase = getDailyOrderCountUseCase,
        super(
          DashboardState(
            reportDateTime: DateTime.now(),
            tour: FeaturesTourController('DashboardView'),
          ),
        );
  final GetDailyOrderCountUseCase _getDailyOrderCountUseCase;
  final GetDailyRevenueUseCase _getDailyRevenueUseCase;
  final GetFiveHighestSalesProductsUseCase _getFiveHighestSalesProductsUseCase;
  final GetFiveLowStockProductsUseCase _getFiveLowStockProductsUseCase;
  final GetDailyRevenueForMonth _getDailyRevenueForMonthUseCase;
  final GetThreeRecentOrdersUseCase _getThreeRecentOrdersUseCase;
  final GetTotalProductCountUseCase _getTotalProductCountUseCase;

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final totalProductCountFuture = _getTotalProductCountUseCase(NoParams());
      final fiveLowStockProductsFuture = _getFiveLowStockProductsUseCase(NoParams());
      final fiveHighestSalesProductsFuture = _getFiveHighestSalesProductsUseCase(NoParams());
      final dailyOrderCountFuture = _getDailyOrderCountUseCase(state.reportDateTime);
      final dailyRevenueFuture = _getDailyRevenueUseCase(state.reportDateTime);
      final threeRecentOrdersFuture = _getThreeRecentOrdersUseCase(NoParams());
      final dailyRevenueForMonthFuture = _getDailyRevenueForMonthUseCase(state.reportDateTime);

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

  Future<void> updateReportDate(DateTime? date) async {
    if (date == null) return;

    state = state.copyWith(reportDateTime: date);
    await loadDashboardData();
  }
}
