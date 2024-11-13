import 'package:sales/data/models/category_model.dart';

abstract interface class CategoryDatabaseRepository {
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
