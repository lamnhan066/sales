import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class GetTemporaryProductUseCase implements UseCase<Product?, NoParams> {
  final TemporaryDataRepository _repository;

  const GetTemporaryProductUseCase(this._repository);

  @override
  Future<Product?> call(NoParams params) {
    return _repository.getProduct();
  }
}
