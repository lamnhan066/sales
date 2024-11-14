import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/discount.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class GetAllDiscountsUseCase implements UseCase<List<Discount>, NoParams> {
  const GetAllDiscountsUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<List<Discount>> call(NoParams params) {
    return _repository.getAllDiscounts();
  }
}
