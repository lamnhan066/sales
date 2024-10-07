import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/infrastucture/database/database.dart';
import 'package:sales/models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Database _database;

  const ProductRepositoryImpl(this._database);

  @override
  Future<List<Product>> getFiveHighestSalesProducts() {
    return _database.getFiveHighestSalesProducts();
  }

  @override
  Future<List<Product>> getFiveLowStockProducts() async {
    return _database.getFiveLowStockProducts();
  }

  @override
  Future<Product> getProductById(int id) {
    return _database.getProductById(id);
  }

  @override
  Future<int> getTotalProductCount() {
    return _database.getTotalProductCount();
  }
}
