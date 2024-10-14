import 'dart:io';

import 'package:sales/domain/entities/backup_data.dart';

abstract interface class BackupRestoreRepository {
  Future<File> backup(BackupData params);
  Future<BackupData> restore();
}
