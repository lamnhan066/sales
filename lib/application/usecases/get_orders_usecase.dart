import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/repositories/order_repository.dart';
import 'package:sales/models/order.dart';

class GetOrdersUseCase implements UseCase<({List<Order> orders, int totalCount}), GetOrderParams> {
  final OrderRepository _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<({List<Order> orders, int totalCount})> call(GetOrderParams params) {
    return _repository.getOrders(params);
  }
}
