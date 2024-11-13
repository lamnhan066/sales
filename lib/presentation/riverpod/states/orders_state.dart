import 'package:equatable/equatable.dart';
import 'package:features_tour/features_tour.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:screenshot/screenshot.dart';

class OrdersState with EquatableMixin {
  OrdersState({
    required this.tour,
    required this.screenshot,
    this.orders = const [],
    this.perPage = 10,
    this.page = 1,
    this.totalPage = 0,
    Ranges<DateTime?>? dateRange,
    this.hasDraft = false,
    this.isShownDraftDialog = false,
    this.isLoading = false,
    this.error = '',
  }) : _dateRange = dateRange;

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
  final ScreenshotController screenshot;

  final bool hasDraft;
  final bool isShownDraftDialog;

  final bool isLoading;
  final String error;

  OrdersState copyWith({
    List<Order>? orders,
    int? perPage,
    int? page,
    int? totalPage,
    Ranges<DateTime?>? dateRange,
    FeaturesTourController? tour,
    ScreenshotController? screenshot,
    bool? hasDraft,
    bool? isShownDraftDialog,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      dateRange: dateRange ?? this.dateRange,
      tour: tour ?? this.tour,
      screenshot: screenshot ?? this.screenshot,
      hasDraft: hasDraft ?? this.hasDraft,
      isShownDraftDialog: isShownDraftDialog ?? this.isShownDraftDialog,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  OrdersState updateDateRange(Ranges<DateTime?>? dateRange) {
    _dateRange = dateRange;
    // ignore: avoid_returning_this
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
      hasDraft,
      isShownDraftDialog,
    ];
  }
}
