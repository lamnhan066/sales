import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class GetNextOrderIdUseCase implements UseCase<int, NoParams> {
  final OrderRepository _repository;

  const GetNextOrderIdUseCase(this._repository);

  @override
  Future<int> call(NoParams params) {
    return _repository.getNextOrderId();
  }
}
