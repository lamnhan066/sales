import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetThreeRecentOrdersUseCase implements UseCase<RecentOrdersResult, NoParams> {
  final ReportRepository _orderRepository;

  const GetThreeRecentOrdersUseCase(this._orderRepository);

  @override
  Future<RecentOrdersResult> call(NoParams params) async {
    return await _orderRepository.getThreeRecentOrders();
  }
}