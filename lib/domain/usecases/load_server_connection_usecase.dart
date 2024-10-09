import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/services/database_service.dart';

class LoadServerConnectionUsecase implements UseCase<void, NoParams> {
  final DatabaseService _service;

  const LoadServerConnectionUsecase(this._service);

  @override
  Future<void> call(NoParams params) {
    return _service.initial();
  }
}
