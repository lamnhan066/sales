import 'package:sales/models/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> removeCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<int> getNextCategoryId();
  Future<List<Category>> getAllCategories();
  Future<void> addAllCategories(List<Category> categories);
  Future<void> removeAllCategories();
}
