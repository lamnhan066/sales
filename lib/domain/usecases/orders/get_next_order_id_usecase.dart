import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/order_repository.dart';

class GetNextOrderIdUseCase implements UseCase<int, NoParams> {

  const GetNextOrderIdUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<int> call(NoParams params) {
    return _repository.getNextOrderId();
  }
}
