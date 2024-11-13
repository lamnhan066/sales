import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetNextProductIdAndSkuUseCase implements UseCase<({int id, String sku}), NoParams> {

  const GetNextProductIdAndSkuUseCase(this._productRepository);
  final ProductRepository _productRepository;

  @override
  Future<({int id, String sku})> call(NoParams params) {
    return _productRepository.getNextProductIdAndSku();
  }
}
