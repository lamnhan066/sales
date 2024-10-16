import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';

abstract class TemporaryDataRepository {
  Future<void> saveProduct(Product product);
  Future<void> removeProduct();
  Future<Product?> getProduct();

  Future<void> saveOrder(OrderWithItemsParams params);
  Future<void> removeOrder();
  Future<OrderWithItemsParams?> getOrder();
}
