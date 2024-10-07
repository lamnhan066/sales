import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/application/usecases/get_daily_order_count_usecase.dart';
import 'package:sales/application/usecases/get_daily_revenues_usecase.dart';
import 'package:sales/application/usecases/get_five_highest_sales_products_usecase.dart';
import 'package:sales/application/usecases/get_five_low_stock_products_usecase.dart';
import 'package:sales/application/usecases/get_monthly_revenues_usecase.dart';
import 'package:sales/application/usecases/get_three_recent_orders_usecase.dart';
import 'package:sales/application/usecases/get_total_product_count_usecase.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/models/product.dart';

class DashboardState {
  /// Tổng tất cả sản phẩm.
  int totalProductCount = 0;

  /// Năm sản phẩm có số lượng trong kho thấp (< 5).
  List<Product> fiveLowStockProducts;

  /// Năm sản phẩm bán chạy nhất.
  List<Product> fiveHighestSalesProducts;

  /// Số đơn hàng bán hằng ngày.
  int dailyOrderCount = 0;

  /// Doanh thu hằng ngày.
  int dailyRevenue = 0;

  /// Ba đơn hàng gần nhất.
  RecentOrdersResult threeRecentOrders;

  /// Doanh thu hằng tháng.
  List<int> monthlyRevenues = [];

  /// Đang load.
  final bool isLoading;

  /// Thông tin lỗi.
  final String error;

  DashboardState({
    this.totalProductCount = 0,
    this.fiveLowStockProducts = const [],
    this.fiveHighestSalesProducts = const [],
    this.dailyOrderCount = 0,
    this.dailyRevenue = 0,
    this.threeRecentOrders = const RecentOrdersResult(orderItems: {}, products: {}),
    this.monthlyRevenues = const [],
    this.isLoading = true,
    this.error = '',
  });

  DashboardState copyWith({
    int? totalProductCount,
    List<Product>? fiveLowStockProducts,
    List<Product>? fiveHighestSalesProducts,
    int? dailyOrderCount,
    int? dailyRevenue,
    RecentOrdersResult? threeRecentOrders,
    List<int>? monthlyRevenues,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      totalProductCount: totalProductCount ?? this.totalProductCount,
      fiveLowStockProducts: fiveLowStockProducts ?? this.fiveLowStockProducts,
      fiveHighestSalesProducts: fiveHighestSalesProducts ?? this.fiveHighestSalesProducts,
      dailyOrderCount: dailyOrderCount ?? this.dailyOrderCount,
      dailyRevenue: dailyRevenue ?? this.dailyRevenue,
      threeRecentOrders: threeRecentOrders ?? this.threeRecentOrders,
      monthlyRevenues: monthlyRevenues ?? this.monthlyRevenues,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDailyOrderCountUseCase getDailyOrderCountUseCase;
  final GetDailyRevenueUseCase getDailyRevenueUseCase;
  final GetFiveHighestSalesProductsUseCase getFiveHighestSalesProductsUseCase;
  final GetFiveLowStockProductsUseCase getFiveLowStockProductsUseCase;
  final GetMonthlyRevenuesUseCase getMonthlyRevenuesUseCase;
  final GetThreeRecentOrdersUseCase getThreeRecentOrdersUseCase;
  final GetTotalProductCountUseCase getTotalProductCountUseCase;

  DashboardNotifier({
    required this.getDailyOrderCountUseCase,
    required this.getDailyRevenueUseCase,
    required this.getFiveHighestSalesProductsUseCase,
    required this.getFiveLowStockProductsUseCase,
    required this.getMonthlyRevenuesUseCase,
    required this.getThreeRecentOrdersUseCase,
    required this.getTotalProductCountUseCase,
  }) : super(DashboardState()) {
    loadDashboardData();
  }

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
      final monthlyRevenuesFuture = getMonthlyRevenuesUseCase(now);

      final results = await Future.wait([
        totalProductCountFuture,
        fiveLowStockProductsFuture,
        fiveHighestSalesProductsFuture,
        dailyOrderCountFuture,
        dailyRevenueFuture,
        threeRecentOrdersFuture,
        monthlyRevenuesFuture,
      ]);

      state = state.copyWith(
        totalProductCount: results[0] as int,
        fiveLowStockProducts: results[1] as List<Product>,
        fiveHighestSalesProducts: results[2] as List<Product>,
        dailyOrderCount: results[3] as int,
        dailyRevenue: results[4] as int,
        threeRecentOrders: results[5] as RecentOrdersResult,
        monthlyRevenues: results[6] as List<int>,
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

final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    getTotalProductCountUseCase: getIt(),
    getFiveLowStockProductsUseCase: getIt(),
    getFiveHighestSalesProductsUseCase: getIt(),
    getDailyOrderCountUseCase: getIt(),
    getDailyRevenueUseCase: getIt(),
    getThreeRecentOrdersUseCase: getIt(),
    getMonthlyRevenuesUseCase: getIt(),
  );
});
