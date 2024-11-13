import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class GetOrdersUseCase implements UseCase<GetResult<Order>, GetOrderParams> {

  const GetOrdersUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<GetResult<Order>> call(GetOrderParams params) {
    return _repository.getOrders(params);
  }
}
