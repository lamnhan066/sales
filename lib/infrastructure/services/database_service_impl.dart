import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/data/mappers/category_mapper_extension.dart';
import 'package:sales/data/mappers/product_mapper_extension.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/data_sync_database_repository.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/infrastructure/exceptions/server_exception.dart';

class DatabaseServiceImpl implements DatabaseService {

  const DatabaseServiceImpl({
    required CoreDatabaseRepository coreDatabase,
    required DataSyncDatabaseRepository dataSyncDatabase,
    required FilePicker filePicker,
  })  : _coreDatabase = coreDatabase,
        _dataSyncDatabase = dataSyncDatabase,
        _filePicker = filePicker;
  final CoreDatabaseRepository _coreDatabase;
  final DataSyncDatabaseRepository _dataSyncDatabase;
  final FilePicker _filePicker;

  @override
  Future<void> initial() async {
    try {
      await _coreDatabase.initial();
    } catch (e) {
      throw ServerException('Không thể kết nối được với máy chủ'.tr);
    }
  }

  @override
  Future<void> dispose() async {
    await _coreDatabase.dispose();
  }

  @override
  Future<void> mergeDatabase(DataImportResult data) {
    final categories = data.categories.map((e) => e.toData()).toList();
    final products = data.products.map((e) => e.toData()).toList();
    return _dataSyncDatabase.merge(categories, products);
  }

  @override
  Future<void> replaceDatabase(DataImportResult data) {
    final categories = data.categories.map((e) => e.toData()).toList();
    final products = data.products.map((e) => e.toData()).toList();
    return _dataSyncDatabase.replace(categories, products);
  }

  @override
  Future<void> downloadTemplate() async {
    final path = await _filePicker.saveFile(
      dialogTitle: 'Lưu Danh Sách Sản Phẩm Mẫu'.tr,
      fileName: 'product_template.xlsx',
    );

    if (path == null) {
      throw ServerException('Không có đường dẫn được chọn'.tr);
    }

    try {
      final file = File(path);
      final data = await rootBundle.load('assets/templates/products.xlsx');
      file.writeAsBytesSync(data.buffer.asUint8List());
    } catch (e) {
      throw ServerException('Không thể ghi sản phẩm mẫu vào tệp'.tr);
    }
  }
}
