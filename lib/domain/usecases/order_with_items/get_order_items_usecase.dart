import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/order_item.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';

class GetOrderItemsUseCase implements UseCase<List<OrderItem>, GetOrderItemsParams> {

  const GetOrderItemsUseCase(this._repository);
  final OrderItemRepository _repository;

  @override
  Future<List<OrderItem>> call(GetOrderItemsParams params) {
    return _repository.getOrderItems(params);
  }
}
