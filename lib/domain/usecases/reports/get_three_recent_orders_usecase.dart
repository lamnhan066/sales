import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/domain/repositories/report_repository.dart';

class GetThreeRecentOrdersUseCase implements UseCase<RecentOrdersResult, NoParams> {

  const GetThreeRecentOrdersUseCase(this._orderRepository);
  final ReportRepository _orderRepository;

  @override
  Future<RecentOrdersResult> call(NoParams params) async {
    return _orderRepository.getThreeRecentOrders();
  }
}
