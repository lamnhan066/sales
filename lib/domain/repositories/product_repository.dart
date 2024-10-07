import 'package:sales/models/product.dart';

abstract class ProductRepository {
  Future<int> getTotalProductCount();
  Future<List<Product>> getFiveLowStockProducts();
  Future<List<Product>> getFiveHighestSalesProducts();
  Future<Product> getProductById(int id);
}
