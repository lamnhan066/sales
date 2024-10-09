import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetNextProductIdAndSkuUseCase implements UseCase<({int id, String sku}), NoParams> {
  final ProductRepository _productRepository;

  const GetNextProductIdAndSkuUseCase(this._productRepository);

  @override
  Future<({int id, String sku})> call(NoParams params) {
    return _productRepository.getNextProductIdAndSku();
  }
}
