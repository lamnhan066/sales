import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';

class RemoveTemporaryOrderWithItemsUseCase implements UseCase<void, NoParams> {
  final TemporaryDataRepository _repository;

  const RemoveTemporaryOrderWithItemsUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.removeOrder();
  }
}
