import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class RemoveOrderWithItemsUseCase implements UseCase<void, Order> {

  const RemoveOrderWithItemsUseCase(this._orderRepository);
  final OrderWithItemsRepository _orderRepository;

  @override
  Future<void> call(Order order) {
    return _orderRepository.removeOrderWithItems(order);
  }
}
