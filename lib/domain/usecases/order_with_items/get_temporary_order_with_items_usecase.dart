import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class GetTemporaryOrderWithItemsUseCase implements UseCase<OrderWithItemsParams?, NoParams> {

  const GetTemporaryOrderWithItemsUseCase(this._repository);
  final TemporaryDataRepository _repository;

  @override
  Future<OrderWithItemsParams?> call(NoParams params) {
    return _repository.getOrder();
  }
}
