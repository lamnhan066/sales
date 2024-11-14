import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class UpdateDiscountUseCase implements UseCase<void, Discount> {
  const UpdateDiscountUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<void> call(Discount discount) {
    return _repository.updateDiscount(discount);
  }
}
