import 'package:equatable/equatable.dart';
import 'package:features_tour/features_tour.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

class DashboardState with EquatableMixin {

  DashboardState({
    required this.reportDateTime, required this.tour, this.totalProductCount = 0,
    this.fiveLowStockProducts = const [],
    this.fiveHighestSalesProducts = const {},
    this.dailyOrderCount = 0,
    this.dailyRevenue = 0,
    this.threeRecentOrders = const RecentOrdersResult(),
    this.dailyRevenueForMonth = const [],
    this.isLoading = true,
    this.error = '',
  });
  /// Tổng tất cả sản phẩm.
  final int totalProductCount;

  /// Năm sản phẩm có số lượng trong kho thấp (< 5).
  final List<Product> fiveLowStockProducts;

  /// Năm sản phẩm bán chạy nhất và số lượng tương ứng.
  final Map<Product, int> fiveHighestSalesProducts;

  /// Số đơn hàng bán hằng ngày.
  final int dailyOrderCount;

  /// Doanh thu hằng ngày.
  final int dailyRevenue;

  /// Ba đơn hàng gần nhất.
  final RecentOrdersResult threeRecentOrders;

  /// Doanh thu từng ngày trong tháng.
  final List<int> dailyRevenueForMonth;

  /// Ngày cho doanh thu từng ngày trong tháng.
  final DateTime reportDateTime;

  /// Đang load.
  final bool isLoading;

  /// Thông tin lỗi.
  final String error;

  final FeaturesTourController tour;

  DashboardState copyWith({
    int? totalProductCount,
    List<Product>? fiveLowStockProducts,
    Map<Product, int>? fiveHighestSalesProducts,
    int? dailyOrderCount,
    int? dailyRevenue,
    RecentOrdersResult? threeRecentOrders,
    List<int>? dailyRevenueForMonth,
    DateTime? reportDateTime,
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
      reportDateTime: reportDateTime ?? this.reportDateTime,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      tour: tour,
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
      error,
      tour.pageName,
    ];
  }
}
