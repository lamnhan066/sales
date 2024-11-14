import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class GetDiscountsByOrderIdUseCase implements UseCase<List<Discount>, int> {
  const GetDiscountsByOrderIdUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<List<Discount>> call(int id) {
    return _repository.getDiscountsByOrderId(id);
  }
}
