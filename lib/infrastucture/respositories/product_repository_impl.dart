import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/infrastucture/database/database.dart';

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

  @override
  Future<void> addProduct(Product product) {
    return _database.addProduct(product);
  }

  @override
  Future<({int id, String sku})> getNextProductIdAndSku() {
    return _database.generateProductIdSku();
  }

  @override
  Future<void> removeProduct(Product product) {
    return _database.removeProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) {
    return _database.updateProduct(product);
  }

  @override
  Future<({List<Product> products, int totalCount})> getProducts(GetProductParams params) {
    return _database.getProducts(params);
  }

  @override
  Future<void> addAllProducts(List<Product> products) {
    return _database.addAllProducts(products);
  }

  @override
  Future<void> removeAllProducts() {
    return _database.removeAllProducts();
  }
}
