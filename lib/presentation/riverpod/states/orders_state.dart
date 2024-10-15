import 'package:equatable/equatable.dart';
import 'package:features_tour/features_tour.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/ranges.dart';

class OrdersState with EquatableMixin {
  /// Danh sách đơn hàng.
  final List<Order> orders;

  /// Số đơn hàng mỗi trang.
  final int perPage;

  /// Vị trí trang hiện tại.
  final int page;

  /// Tổng số trang.
  final int totalPage;

  /// Khoảng ngày khi lọc.
  Ranges<DateTime?>? get dateRange => _dateRange;
  Ranges<DateTime?>? _dateRange;

  final FeaturesTourController tour;

  final bool isLoading;
  final String error;

  OrdersState({
    this.orders = const [],
    this.perPage = 10,
    this.page = 1,
    this.totalPage = 0,
    Ranges<DateTime?>? dateRange,
    this.isLoading = false,
    this.error = '',
    required this.tour,
  }) : _dateRange = dateRange;

  OrdersState copyWith({
    List<Order>? orders,
    int? perPage,
    int? page,
    int? totalPage,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      tour: tour,
    ).._dateRange = dateRange;
  }

  OrdersState updateDateRange(Ranges<DateTime?>? dateRange) {
    _dateRange = dateRange;
    return this;
  }

  @override
  List<Object?> get props {
    return [
      orders,
      perPage,
      page,
      totalPage,
      _dateRange,
      isLoading,
      error,
      tour.pageName,
    ];
  }
}
