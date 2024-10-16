import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class SaveTemporaryOrderWithItemsUseCase implements UseCase<void, OrderWithItemsParams> {
  final TemporaryDataRepository _repository;

  const SaveTemporaryOrderWithItemsUseCase(this._repository);

  @override
  Future<void> call(OrderWithItemsParams params) {
    return _repository.saveOrder(params);
  }
}
