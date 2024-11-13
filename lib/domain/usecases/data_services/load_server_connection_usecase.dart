import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/infrastructure/exceptions/server_exception.dart';

class LoadServerConnectionUsecase implements UseCase<void, NoParams> {

  const LoadServerConnectionUsecase(this._service);
  final DatabaseService _service;

  @override
  Future<void> call(NoParams params) async {
    try {
      await _service.initial();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
