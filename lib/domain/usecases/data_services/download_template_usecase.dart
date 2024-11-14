import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/infrastructure/exceptions/infrastructure_exception.dart';

class DownloadTemplateUseCase implements UseCase<void, NoParams> {
  const DownloadTemplateUseCase(this._service);
  final DatabaseService _service;

  @override
  Future<void> call(NoParams params) async {
    try {
      await _service.downloadTemplate();
    } on InfrastructureException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
