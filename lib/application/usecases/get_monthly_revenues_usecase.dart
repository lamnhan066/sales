import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class GetMonthlyRevenuesUseCase implements UseCase<List<int>, DateTime> {
  final OrderRepository _orderRepository;

  const GetMonthlyRevenuesUseCase(this._orderRepository);

  @override
  Future<List<int>> call(DateTime dateTime) async {
    return await _orderRepository.getMonthlyRevenues(dateTime);
  }
}
