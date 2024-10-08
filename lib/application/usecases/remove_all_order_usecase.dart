import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class RemoveAllOrderUseCase implements UseCase<void, NoParams> {
  final OrderRepository _repository;

  const RemoveAllOrderUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.removeAllOrdersWithOrderItems();
  }
}
