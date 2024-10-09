import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class RemoveOrderWithItemsUseCase implements UseCase<void, Order> {
  final OrderRepository _orderRepository;

  const RemoveOrderWithItemsUseCase(this._orderRepository);

  @override
  Future<void> call(Order order) {
    return _orderRepository.removeOrderWithItems(order);
  }
}
