import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/product_repository.dart';

class GetTotalProductCountUseCase implements UseCase<int, NoParams> {

  const GetTotalProductCountUseCase(this._productRepository);
  final ProductRepository _productRepository;

  @override
  Future<int> call(NoParams params) async {
    return _productRepository.getTotalProductCount();
  }
}
