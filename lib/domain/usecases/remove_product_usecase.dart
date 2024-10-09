import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class RemoveProductUseCase implements UseCase<void, Product> {
  final ProductRepository _productRepository;

  const RemoveProductUseCase(this._productRepository);

  @override
  Future<void> call(Product product) {
    return _productRepository.removeProduct(product);
  }
}
