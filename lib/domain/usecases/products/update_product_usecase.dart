import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class UpdateProductUseCase implements UseCase<void, Product> {

  const UpdateProductUseCase(this._productRepository);
  final ProductRepository _productRepository;

  @override
  Future<void> call(Product product) {
    return _productRepository.updateProduct(product);
  }
}
