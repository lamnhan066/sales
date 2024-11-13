import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_item_repository.dart';

class GetNextOrderItemIdUseCase implements UseCase<int, NoParams> {

  const GetNextOrderItemIdUseCase(this._repository);
  final OrderItemRepository _repository;

  @override
  Future<int> call(NoParams params) {
    return _repository.getNextOrderItemId();
  }
}
