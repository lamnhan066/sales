import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class UpdateOrderWithItemsUseCase implements UseCase<void, OrderWithItemsParams> {
  final OrderRepository _orderRepository;

  const UpdateOrderWithItemsUseCase(this._orderRepository);

  @override
  Future<void> call(OrderWithItemsParams params) {
    return _orderRepository.updateOrderWithItems(params);
  }
}
