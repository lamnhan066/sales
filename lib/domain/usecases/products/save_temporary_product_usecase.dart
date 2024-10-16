import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class SaveTemporaryProductUseCase implements UseCase<void, Product> {
  final TemporaryDataRepository _repository;

  const SaveTemporaryProductUseCase(this._repository);

  @override
  Future<void> call(Product params) {
    return _repository.saveProduct(params);
  }
}
