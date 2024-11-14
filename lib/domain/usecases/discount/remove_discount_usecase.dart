import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class RemoveDiscountUseCase implements UseCase<void, Discount> {
  const RemoveDiscountUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<void> call(Discount params) {
    return _repository.removeUnusedDiscount(params);
  }
}
