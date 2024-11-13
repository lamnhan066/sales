import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class RemoveTemporaryProductUseCase implements UseCase<void, NoParams> {

  const RemoveTemporaryProductUseCase(this._repository);
  final TemporaryDataRepository _repository;

  @override
  Future<void> call(NoParams params) {
    return _repository.removeProduct();
  }
}
