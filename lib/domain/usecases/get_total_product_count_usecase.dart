import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetTotalProductCountUseCase implements UseCase<int, NoParams> {
  final ProductRepository _productRepository;

  const GetTotalProductCountUseCase(this._productRepository);

  @override
  Future<int> call(NoParams params) async {
    return await _productRepository.getTotalProductCount();
  }
}
