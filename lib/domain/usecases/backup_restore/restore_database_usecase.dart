import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';
import 'package:sales/infrastructure/exceptions/backup_exception.dart';

class RestoreDatabaseUseCase implements UseCase<BackupData, NoParams> {
  final BackupRestoreRepository _repository;

  const RestoreDatabaseUseCase(this._repository);

  @override
  Future<BackupData> call(NoParams params) async {
    try {
      return await _repository.restore();
    } on BackupException catch (e) {
      throw BackupFailure(e.message);
    }
  }
}
