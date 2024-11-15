import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class AddOrderWithItemsUseCase implements UseCase<int, OrderWithItemsParams> {
  const AddOrderWithItemsUseCase(this._orderRepository);
  final OrderWithItemsRepository _orderRepository;

  @override
  Future<int> call(OrderWithItemsParams params) {
    return _orderRepository.addOrderWithItems(params);
  }
}
