import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class GetTemporaryProductUseCase implements UseCase<Product?, NoParams> {

  const GetTemporaryProductUseCase(this._repository);
  final TemporaryDataRepository _repository;

  @override
  Future<Product?> call(NoParams params) {
    return _repository.getProduct();
  }
}
