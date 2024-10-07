import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class GetDailyOrderCountUseCase implements UseCase<int, DateTime> {
  final OrderRepository _orderRepository;

  const GetDailyOrderCountUseCase(this._orderRepository);

  @override
  Future<int> call(DateTime dateTime) async {
    return await _orderRepository.getDailyOrderCount(dateTime);
  }
}
