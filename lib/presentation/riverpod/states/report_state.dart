import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/ranges.dart';

class ReportState with EquatableMixin {
  final Map<Product, int> soldProductsWithQuantity;
  final int revenue;
  final int profit;
  final Ranges<DateTime> reportDateRange;

  ReportState({
    this.soldProductsWithQuantity = const {},
    this.revenue = 0,
    this.profit = 0,
    required this.reportDateRange,
  });

  ReportState copyWith({
    Map<Product, int>? soldProductsWithQuantity,
    int? revenue,
    int? profit,
    Ranges<DateTime>? reportDateRange,
  }) {
    return ReportState(
      soldProductsWithQuantity: soldProductsWithQuantity ?? this.soldProductsWithQuantity,
      revenue: revenue ?? this.revenue,
      profit: profit ?? this.profit,
      reportDateRange: reportDateRange ?? this.reportDateRange,
    );
  }

  @override
  List<Object> get props => [soldProductsWithQuantity, revenue, profit, reportDateRange];
}
