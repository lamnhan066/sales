import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetFiveLowStockProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository _productRepository;

  const GetFiveLowStockProductsUseCase(this._productRepository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await _productRepository.getFiveLowStockProducts();
  }
}
