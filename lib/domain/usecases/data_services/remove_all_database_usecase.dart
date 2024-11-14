import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/data/repositories/core_database_repository.dart';

class RemoveAllDatabaseUseCase implements UseCase<void, NoParams> {
  const RemoveAllDatabaseUseCase(this._core);
  final CoreDatabaseRepository _core;

  @override
  Future<void> call(NoParams params) {
    return _core.clear();
  }
}
