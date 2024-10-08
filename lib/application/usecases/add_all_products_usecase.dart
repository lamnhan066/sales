import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class AddAllProductsUseCase implements UseCase<void, List<Product>> {
  final ProductRepository _repository;

  const AddAllProductsUseCase(this._repository);

  @override
  Future<void> call(List<Product> products) {
    return _repository.addAllProducts(products);
  }
}
