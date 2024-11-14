import 'dart:io';

import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';
import 'package:sales/infrastructure/exceptions/backup_exception.dart';

class BackupDatabaseUseCase implements UseCase<File, BackupData> {
  const BackupDatabaseUseCase(this._repository);
  final BackupRestoreRepository _repository;

  @override
  Future<File> call(BackupData params) async {
    try {
      return await _repository.backup(params);
    } on BackupException catch (e) {
      throw BackupFailure(e.message);
    }
  }
}
