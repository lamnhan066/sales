import 'package:equatable/equatable.dart';
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

class DashboardState with EquatableMixin {
  /// Tổng tất cả sản phẩm.
  int totalProductCount = 0;

  /// Năm sản phẩm có số lượng trong kho thấp (< 5).
  List<Product> fiveLowStockProducts;

  /// Năm sản phẩm bán chạy nhất và số lượng tương ứng.
  Map<Product, int> fiveHighestSalesProducts;

  /// Số đơn hàng bán hằng ngày.
  int dailyOrderCount = 0;

  /// Doanh thu hằng ngày.
  int dailyRevenue = 0;

  /// Ba đơn hàng gần nhất.
  RecentOrdersResult threeRecentOrders;

  /// Doanh thu hằng tháng.
  List<int> dailyRevenueForMonth = [];

  /// Đang load.
  final bool isLoading;

  /// Thông tin lỗi.
  final String error;

  DashboardState({
    this.totalProductCount = 0,
    this.fiveLowStockProducts = const [],
    this.fiveHighestSalesProducts = const {},
    this.dailyOrderCount = 0,
    this.dailyRevenue = 0,
    this.threeRecentOrders = const RecentOrdersResult(orderItems: {}, products: {}),
    this.dailyRevenueForMonth = const [],
    this.isLoading = true,
    this.error = '',
  });

  DashboardState copyWith({
    int? totalProductCount,
    List<Product>? fiveLowStockProducts,
    Map<Product, int>? fiveHighestSalesProducts,
    int? dailyOrderCount,
    int? dailyRevenue,
    RecentOrdersResult? threeRecentOrders,
    List<int>? dailyRevenueForMonth,
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
      dailyRevenueForMonth: dailyRevenueForMonth ?? this.dailyRevenueForMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props {
    return [
      totalProductCount,
      fiveLowStockProducts,
      fiveHighestSalesProducts,
      dailyOrderCount,
      dailyRevenue,
      threeRecentOrders,
      dailyRevenueForMonth,
      isLoading,
      error
    ];
  }
}

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
