import 'package:sales/domain/repositories/category_repository.dart';
import 'package:sales/infrastucture/database/database.dart';
import 'package:sales/models/category.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Database _database;

  const CategoryRepositoryImpl(this._database);

  @override
  Future<void> addCategory(Category category) {
    return _database.addCategory(category);
  }

  @override
  Future<List<Category>> getAllCategories() {
    return _database.getAllCategories();
  }

  @override
  Future<int> getNextCategoryId() {
    return _database.getNextCategoryId();
  }

  @override
  Future<void> removeCategory(Category category) {
    return _database.removeCategory(category);
  }

  @override
  Future<void> updateCategory(Category category) {
    return _database.updateCategory(category);
  }

  @override
  Future<void> addAllCategories(List<Category> categories) {
    return _database.addAllCategories(categories);
  }

  @override
  Future<void> removeAllCategories() {
    return _database.removeAllCategories();
  }
}
