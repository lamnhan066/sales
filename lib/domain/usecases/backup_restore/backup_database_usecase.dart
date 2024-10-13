import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';

class BackupDatabaseUseCase implements UseCase<void, BackupData> {
  final BackupRestoreRepository _repository;

  const BackupDatabaseUseCase(this._repository);

  @override
  Future<void> call(BackupData params) {
    return _repository.backup(params);
  }
}
