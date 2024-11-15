import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/repositories/order_with_items_repository.dart';

class GetAllOrdersWithItemsUseCase implements UseCase<List<OrderWithItemsParams>, NoParams> {

  const GetAllOrdersWithItemsUseCase(this._repository);
  final OrderWithItemsRepository _repository;

  @override
  Future<List<OrderWithItemsParams>> call(NoParams params) {
    return _repository.getAllOrdersWithItems();
  }
}
