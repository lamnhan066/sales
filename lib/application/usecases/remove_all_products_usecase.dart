import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class RemoveAllProductsUsecase implements UseCase<void, NoParams> {
  final ProductRepository _repository;

  const RemoveAllProductsUsecase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.removeAllProducts();
  }
}
