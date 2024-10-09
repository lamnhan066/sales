import 'package:sales/data/database/core_database.dart';
import 'package:sales/data/database/data_sync_database.dart';
import 'package:sales/data/mappers/category_mapper_extension.dart';
import 'package:sales/data/mappers/product_mapper_extension.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';

class DatabaseServiceImpl implements DatabaseService {
  final CoreDatabase _coreDatabase;
  final DataSyncDatabase _dataSyncDatabase;

  const DatabaseServiceImpl({
    required CoreDatabase coreDatabase,
    required DataSyncDatabase dataSyncDatabase,
  })  : _coreDatabase = coreDatabase,
        _dataSyncDatabase = dataSyncDatabase;

  @override
  Future<void> initial() async {
    await _coreDatabase.initial();
  }

  @override
  Future<void> dispose() async {
    await _coreDatabase.dispose();
  }

  @override
  Future<void> backupDatabase(String backupPath) {
    // TODO: implement backupDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> restoreDatabase(String backupPath) {
    // TODO: implement restoreDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> mergeDatabase(DataImportResult data) {
    final categories = data.categories.map((e) => e.toCategoryModel()).toList();
    final products = data.products.map((e) => e.toData()).toList();
    return _dataSyncDatabase.merge(categories, products);
  }

  @override
  Future<void> replaceDatabase(DataImportResult data) {
    final categories = data.categories.map((e) => e.toCategoryModel()).toList();
    final products = data.products.map((e) => e.toData()).toList();
    return _dataSyncDatabase.replace(categories, products);
  }
}
