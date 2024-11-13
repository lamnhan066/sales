import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class AddAllOrdersWithItemsUseCase implements UseCase<void, List<OrderWithItemsParams>> {

  const AddAllOrdersWithItemsUseCase(this._repository);
  final OrderWithItemsRepository _repository;

  @override
  Future<void> call(List<OrderWithItemsParams> params) {
    return _repository.addAllOrdersWithItems(params);
  }
}
