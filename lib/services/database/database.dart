import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';

abstract interface class Database {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> removeCategory(Category category);
  Future<List<Category>> getCategories();

  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> removeProduct(Product product);
  Future<List<Product>> getProducts();

  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> removeOrder(Order order);
  Future<List<Order>> getOrders();

  Future<void> addOrderItem(OrderItem orderItem);
  Future<void> updateOrderItem(OrderItem orderItem);
  Future<void> removeOrderItem(OrderItem orderItem);
  Future<List<OrderItem>> getOrderItems();

  Future<int> getTotalProductCount();
  Future<List<Product>> getFiveLowStockProducts();
  Future<List<Product>> getFiveHighestSalesProducts();
  Future<int> getDailyOrderCount(DateTime date);
  Future<int> getDailyRevenue(DateTime date);
  Future<List<Order>> getThreeRecentOrders();
}
