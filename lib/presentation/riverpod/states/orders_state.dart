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
  final Ranges<DateTime>? dateRange;

  final bool isLoading;
  final String error;

  OrdersState({
    this.orders = const [],
    this.perpage = 10,
    this.page = 1,
    this.totalPage = 0,
    this.dateRange,
    this.isLoading = false,
    this.error = '',
  });

  OrdersState copyWith({
    List<Order>? orders,
    int? perpage,
    int? page,
    int? totalPage,
    Ranges<DateTime>? dateRange,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      perpage: perpage ?? this.perpage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      dateRange: dateRange ?? this.dateRange,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props {
    return [
      orders,
      perpage,
      page,
      totalPage,
      dateRange,
      isLoading,
      error,
    ];
  }
}
