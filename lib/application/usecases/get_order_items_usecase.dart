import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/models/order_item.dart';

class GetOrderItemsUseCase implements UseCase<List<OrderItem>, GetOrderItemsParams> {
  final OrderRepository _repository;

  const GetOrderItemsUseCase(this._repository);

  @override
  Future<List<OrderItem>> call(GetOrderItemsParams params) {
    return _repository.getOrderItems(params);
  }
}
