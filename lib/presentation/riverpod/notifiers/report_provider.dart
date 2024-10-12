import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/usecases/reports/get_profit_usecase.dart';
import 'package:sales/domain/usecases/reports/get_revenue_usecase.dart';
import 'package:sales/domain/usecases/reports/get_sold_products_with_quantity_usecase.dart';
import 'package:sales/presentation/riverpod/states/report_state.dart';

final reportProvider = StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  return ReportNotifier(
    getSoldProductsWithQuantityUsecase: getIt(),
    getRevenueUseCase: getIt(),
    getProfitUsecase: getIt(),
  );
});

class ReportNotifier extends StateNotifier<ReportState> {
  final GetSoldProductsWithQuantityUsecase _getSoldProductsWithQuantityUsecase;
  final GetRevenueUseCase _getRevenueUseCase;
  final GetProfitUseCase _getProfitUsecase;

  ReportNotifier({
    required GetSoldProductsWithQuantityUsecase getSoldProductsWithQuantityUsecase,
    required GetRevenueUseCase getRevenueUseCase,
    required GetProfitUseCase getProfitUsecase,
  })  : _getProfitUsecase = getProfitUsecase,
        _getRevenueUseCase = getRevenueUseCase,
        _getSoldProductsWithQuantityUsecase = getSoldProductsWithQuantityUsecase,
        super(ReportState(reportDateRange: SevenDaysRanges(DateTime.now())));

  Future<void> loadReportData() async {
    final soldProductsWithQuantity = await _getSoldProductsWithQuantityUsecase(state.reportDateRange);
    final revenue = await _getRevenueUseCase(state.reportDateRange);
    final profit = await _getProfitUsecase(state.reportDateRange);

    state = state.copyWith(
      soldProductsWithQuantity: soldProductsWithQuantity,
      revenue: revenue,
      profit: profit,
    );
  }

  Future<void> updateFilters(Ranges<DateTime> reportDateRange) async {
    state = state.copyWith(reportDateRange: reportDateRange);
    await loadReportData();
  }
}
