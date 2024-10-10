import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class AddOrderWithItemsUseCase implements UseCase<void, OrderWithItemsParams<Order, OrderItem>> {
  final OrderWithItemsRepository _orderRepository;

  const AddOrderWithItemsUseCase(this._orderRepository);

  @override
  Future<void> call(OrderWithItemsParams<Order, OrderItem> params) {
    return _orderRepository.addOrderWithItems(params);
  }
}
