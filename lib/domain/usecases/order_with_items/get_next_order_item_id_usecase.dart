import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';

class GetNextOrderItemIdUseCase implements UseCase<int, NoParams> {
  final OrderItemRepository _repository;

  const GetNextOrderItemIdUseCase(this._repository);

  @override
  Future<int> call(NoParams params) {
    return _repository.getNextOrderItemId();
  }
}
