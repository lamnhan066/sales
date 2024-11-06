import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/services/database_service.dart';

class DownloadTemplateUseCase implements UseCase<void, NoParams> {
  final DatabaseService _service;

  const DownloadTemplateUseCase(this._service);

  @override
  Future<void> call(NoParams params) async {
    await _service.downloadTemplate();
  }
}
