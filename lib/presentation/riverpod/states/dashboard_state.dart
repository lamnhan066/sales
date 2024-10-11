import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';

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
