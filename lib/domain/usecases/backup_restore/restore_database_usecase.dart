import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';

class RestoreDatabaseUseCase implements UseCase<BackupData, NoParams> {
  final BackupRestoreRepository _repository;

  const RestoreDatabaseUseCase(this._repository);

  @override
  Future<BackupData> call(NoParams params) {
    return _repository.restore();
  }
}
