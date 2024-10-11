import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/ranges.dart';

class OrdersState with EquatableMixin {
  /// Danh sách đơn hàng.
  final List<Order> orders;

  /// Số đơn hàng mỗi trang.
  final int perpage;

  /// Vị trí trang hiện tại.
  final int page;

  /// Tổng số trang.
  final int totalPage;

  /// Khoảng ngày khi lọc.
  Ranges<DateTime?>? get dateRange => _dateRange;
  Ranges<DateTime?>? _dateRange;

  final bool isLoading;
  final String error;

  OrdersState({
    this.orders = const [],
    this.perpage = 10,
    this.page = 1,
    this.totalPage = 0,
    Ranges<DateTime?>? dateRange,
    this.isLoading = false,
    this.error = '',
  }) : _dateRange = dateRange;

  OrdersState copyWith({
    List<Order>? orders,
    int? perpage,
    int? page,
    int? totalPage,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      perpage: perpage ?? this.perpage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
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
      perpage,
      page,
      totalPage,
      _dateRange,
      isLoading,
      error,
    ];
  }
}
