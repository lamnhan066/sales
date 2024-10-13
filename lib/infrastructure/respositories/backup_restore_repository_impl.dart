import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/exceptions/backup_exception.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';

class BackupRestoreRepositoryImpl implements BackupRestoreRepository {
  final FilePicker _filePicker;

  const BackupRestoreRepositoryImpl(this._filePicker);

  @override
  Future<void> backup(BackupData params) async {
    final data = Uint8List.fromList(utf8.encode(params.toJson()));
    await _filePicker.saveFile(
      dialogTitle: 'Lưu Bản Sao Lưu'.tr,
      fileName: 'sales.bak',
      allowedExtensions: ['bak'],
      bytes: data,
    );
  }

  @override
  Future<BackupData> restore() async {
    final file = await _filePicker.pickFiles(
      dialogTitle: 'Chọn Bản Sao Lưu'.tr,
      allowedExtensions: ['bak'],
    );

    if (file == null || file.files.isEmpty) {
      throw NoBackupInputException();
    }

    BackupData data;
    try {
      final bytes = file.files.first.bytes!;
      final decoded = utf8.decode(bytes);
      data = BackupData.fromJson(decoded);
    } catch (e) {
      throw InvalidBackupException();
    }

    return data;
  }
}
