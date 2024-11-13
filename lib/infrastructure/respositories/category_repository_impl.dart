import 'package:sales/data/mappers/category_mapper_extension.dart';
import 'package:sales/data/repositories/category_database_repository.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatabaseRepository _database;

  const CategoryRepositoryImpl(this._database);

  @override
  Future<void> addCategory(Category category) {
    return _database.addCategory(category.toData());
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final categories = await _database.getAllCategories();
    return categories.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> getNextCategoryId() {
    return _database.getNextCategoryId();
  }

  @override
  Future<void> removeCategory(Category category) {
    return _database.removeCategory(category.toData());
  }

  @override
  Future<void> updateCategory(Category category) {
    return _database.updateCategory(category.toData());
  }

  @override
  Future<void> addAllCategories(List<Category> categories) async {
    return _database.addAllCategories(categories.map((e) => e.toData()).toList());
  }
}
