import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/repositories/discount_repository.dart';

class AddDiscountUseCase implements UseCase<void, AddDiscountParams> {
  const AddDiscountUseCase(this._repository);

  final DiscountRepository _repository;

  @override
  Future<void> call(AddDiscountParams params) {
    return _repository.addDiscountPercent(params);
  }
}
