import 'package:sales/domain/entities/data_import_result.dart';

abstract class DatabaseService {
  /// Xoá tất cả các dữ liệu.
  Future<void> clearDatabase();

  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  Future<void> mergeDatabase(DataImportResult data);

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replaceDatabase(DataImportResult data);

  Future<void> backupDatabase(String backupPath);
  Future<void> restoreDatabase(String backupPath);
}
