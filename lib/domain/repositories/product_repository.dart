import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/product.dart';

abstract class ProductRepository {
  Future<void> addProduct(Product product);
  Future<void> removeProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<({int id, String sku})> getNextProductIdAndSku();

  Future<int> getTotalProductCount();
  Future<List<Product>> getFiveLowStockProducts();
  Future<List<Product>> getFiveHighestSalesProducts();
  Future<Product> getProductById(int id);

  Future<({List<Product> products, int totalCount})> getProducts(GetProductParams params);

  Future<void> addAllProducts(List<Product> products);
  Future<void> removeAllProducts();
}
