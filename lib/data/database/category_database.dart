import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/product_model.dart';

abstract interface class CategoryDatabase {
  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products);

  /// Thêm loại hàng mới.
  Future<void> addCategory(CategoryModel category);

  /// Sửa và cập nhật loại hàng,
  Future<void> updateCategory(CategoryModel category);

  /// Xoá loại hàng.
  Future<void> removeCategory(CategoryModel category);

  /// Lấy danh sách tất cả các loại hàng kể cả loại hàng đã bị xoá.
  Future<List<CategoryModel>> getAllCategories();

  /// Lưu tất cả loại hàng vào CSDL.
  Future<void> addAllCategories(List<CategoryModel> categories);

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> getNextCategoryId();
}
