import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/backup_data.dart';
import 'package:sales/domain/repositories/backup_restore_repository.dart';
import 'package:sales/infrastructure/exceptions/backup_exception.dart';

class BackupRestoreRepositoryImpl implements BackupRestoreRepository {
  final FilePicker _filePicker;

  const BackupRestoreRepositoryImpl(this._filePicker);

  @override
  Future<File> backup(BackupData params) async {
    final data = utf8.encode(params.toJson());
    final path = await _filePicker.saveFile(
      dialogTitle: 'Lưu Bản Sao Lưu'.tr,
      fileName: 'sales.bak',
    );

    if (path == null) {
      throw BackupException('Không có đường dẫn được chọn'.tr);
    }

    try {
      final file = File(path);
      await file.writeAsBytes(data);
      return file;
    } catch (e) {
      throw BackupException('Không thể ghi bản sao lưu vào tệp'.tr);
    }
  }

  @override
  Future<BackupData> restore() async {
    final file = await _filePicker.pickFiles(
      dialogTitle: 'Chọn Bản Sao Lưu'.tr,
      withData: true,
    );

    if (file == null || file.files.isEmpty) {
      throw BackupException('Không chọn được bản sao lưu'.tr);
    }

    BackupData data;
    try {
      final bytes = file.files.first.bytes!;
      final decoded = utf8.decode(bytes);
      data = BackupData.fromJson(decoded);
    } catch (e) {
      throw BackupException('Bản sao lưu không đúng định dạng'.tr);
    }

    return data;
  }
}
