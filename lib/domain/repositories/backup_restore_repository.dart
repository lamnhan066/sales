import 'package:sales/domain/entities/backup_data.dart';

abstract interface class BackupRestoreRepository {
  Future<void> backup(BackupData params);
  Future<BackupData> restore();
}
