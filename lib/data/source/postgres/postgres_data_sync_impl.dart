import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/data/repositories/category_database_repository.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/data_sync_database_repository.dart';
import 'package:sales/data/repositories/product_database_repository.dart';

class PostgresDataSyncImpl implements DataSyncDatabaseRepository {
  final CoreDatabaseRepository _core;
  final CategoryDatabaseRepository _category;
  final ProductDatabaseRepository _product;

  const PostgresDataSyncImpl(this._core, this._category, this._product);

  @override
  Future<void> merge(List<CategoryModel> categories, List<ProductModel> products) async {
    final tempCategories = await _category.getAllCategories();
    final cIndex = tempCategories.length;
    for (int i = 0; i < categories.length; i++) {
      final c = categories.elementAt(i).copyWith(id: cIndex + i);
      tempCategories.add(c);
    }
    await _category.addAllCategories(tempCategories);

    final tempProducts = await _product.getAllProducts();
    final pIndex = tempProducts.length;
    for (int i = 0; i < products.length; i++) {
      final newIndex = pIndex + i;
      final p = products.elementAt(i).copyWith(
            id: newIndex,
            sku: 'P${newIndex.toString().padLeft(8, '0')}',
          );
      tempProducts.add(p);
    }
    await _product.addAllProducts(tempProducts);
  }

  @override
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products) async {
    await _core.clear();
    await _category.addAllCategories(categories);
    await _product.addAllProducts(products);
  }
}
