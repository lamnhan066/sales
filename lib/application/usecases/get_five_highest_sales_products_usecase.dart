import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/models/product.dart';

class GetFiveHighestSalesProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository _productRepository;

  const GetFiveHighestSalesProductsUseCase(this._productRepository);

  @override
  Future<List<Product>> call(params) async {
    return await _productRepository.getFiveHighestSalesProducts();
  }
}
