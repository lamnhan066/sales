import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class AddAllDiscountsUseCase implements UseCase<void, List<Discount>> {
  const AddAllDiscountsUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<void> call(List<Discount> params) {
    return _repository.addAllDiscounts(params);
  }
}
