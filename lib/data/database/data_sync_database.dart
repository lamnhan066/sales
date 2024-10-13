import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/product_model.dart';

abstract interface class DataSyncDatabase {
  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  Future<void> merge(List<CategoryModel> categories, List<ProductModel> products);

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products);
}
