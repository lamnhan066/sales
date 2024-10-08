import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/services/database_service.dart';
import 'package:sales/infrastucture/database/database.dart';

class DatabaseServiceImpl implements DatabaseService {
  final Database _database;

  const DatabaseServiceImpl(this._database);

  @override
  Future<void> backupDatabase(String backupPath) {
    // TODO: implement backupDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> clearDatabase() {
    return _database.clear();
  }

  @override
  Future<void> restoreDatabase(String backupPath) {
    // TODO: implement restoreDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> mergeDatabase(DataImportResult data) {
    return _database.merge(data.categories, data.products);
  }

  @override
  Future<void> replaceDatabase(DataImportResult data) {
    return _database.replace(data.categories, data.products);
  }
}
