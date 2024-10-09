import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class UpdateOrderWithItemsUseCase implements UseCase<void, OrderWithItemsParams<Order, OrderItem>> {
  final OrderRepository _orderRepository;

  const UpdateOrderWithItemsUseCase(this._orderRepository);

  @override
  Future<void> call(OrderWithItemsParams<Order, OrderItem> params) {
    return _orderRepository.updateOrderWithItems(params);
  }
}
