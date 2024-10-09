import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetFiveHighestSalesProductsUseCase implements UseCase<Map<Product, int>, NoParams> {
  final ProductRepository _productRepository;

  const GetFiveHighestSalesProductsUseCase(this._productRepository);

  @override
  Future<Map<Product, int>> call(params) async {
    return await _productRepository.getFiveHighestSalesProducts();
  }
}
