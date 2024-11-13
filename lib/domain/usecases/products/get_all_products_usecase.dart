import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetAllProductsUseCase implements UseCase<List<Product>, NoParams> {

  const GetAllProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<List<Product>> call(NoParams params) {
    return _repository.getAllProducts();
  }
}
