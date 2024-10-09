import 'package:sales/data/mappers/category_mapper_extension.dart';
import 'package:sales/data/mappers/product_mapper_extension.dart';
import 'package:sales/data/repositories/database.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';

class DatabaseServiceImpl implements DatabaseService {
  final Database _database;

  const DatabaseServiceImpl(this._database);

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
    return _database.merge(categories, products);
  }

  @override
  Future<void> replaceDatabase(DataImportResult data) {
    final categories = data.categories.map((e) => e.toCategoryModel()).toList();
    final products = data.products.map((e) => e.toData()).toList();
    return _database.replace(categories, products);
  }
}
