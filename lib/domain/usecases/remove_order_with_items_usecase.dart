import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class RemoveOrderWithItemsUseCase implements UseCase<void, Order> {
  final OrderWithItemsRepository _orderRepository;

  const RemoveOrderWithItemsUseCase(this._orderRepository);

  @override
  Future<void> call(Order order) {
    return _orderRepository.removeOrderWithItems(order);
  }
}
