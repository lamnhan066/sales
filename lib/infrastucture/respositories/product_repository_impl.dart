import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/product_repository.dart';
import 'package:sales/infrastucture/database/database.dart';
import 'package:sales/infrastucture/database/mappers/product_mapper_extension.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Database _database;

  const ProductRepositoryImpl(this._database);

  @override
  Future<Map<Product, int>> getFiveHighestSalesProducts() async {
    final result = await _database.getFiveHighestSalesProducts();
    return result.map((k, v) => MapEntry(k.toDomain(), v));
  }

  @override
  Future<List<Product>> getFiveLowStockProducts() async {
    final result = await _database.getFiveLowStockProducts();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final result = await _database.getProductById(id);
    return result.toDomain();
  }

  @override
  Future<int> getTotalProductCount() {
    return _database.getTotalProductCount();
  }

  @override
  Future<void> addProduct(Product product) {
    return _database.addProduct(product.toData());
  }

  @override
  Future<({int id, String sku})> getNextProductIdAndSku() {
    return _database.getNextProductIdSku();
  }

  @override
  Future<void> removeProduct(Product product) {
    return _database.removeProduct(product.toData());
  }

  @override
  Future<void> updateProduct(Product product) {
    return _database.updateProduct(product.toData());
  }

  @override
  Future<GetResult<Product>> getProducts(GetProductParams params) async {
    final result = await _database.getProducts(params);
    return GetResult(totalCount: result.totalCount, items: result.items.map((e) => e.toDomain()).toList());
  }

  @override
  Future<void> addAllProducts(List<Product> products) {
    return _database.addAllProducts(products.map((e) => e.toData()).toList());
  }

  @override
  Future<List<Product>> getAllProducts() async {
    final result = await _database.getAllProducts();
    return result.map((e) => e.toDomain()).toList();
  }
}
