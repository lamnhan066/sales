import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<GetResult<Product>, GetProductParams> {

  const GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<GetResult<Product>> call([GetProductParams params = const GetProductParams()]) {
    return _repository.getProducts(params);
  }
}
