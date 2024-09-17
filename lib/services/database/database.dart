import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';

abstract interface class Database {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> removeCategory(Category category);
  Future<List<Category>> getAllCategories();

  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> removeProduct(Product product);

  /// Lấy danh sách sản phẩm.
  ///
  /// Lấy danh sách sản phẩm ở trang [page] cụ thể, mỗi trang sẽ chứa [perpage]
  /// sản phẩm.
  Future<List<Product>> getProducts({
    int page = 0,
    int perpage = 10,
    ProductOrderBy orderBy = ProductOrderBy.none,
    String filter = '',
  });

  /// Lấy tổng số sản phẩm.
  Future<int> getTotalProductsCount({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String filter = '',
  });

  /// Lấy toàn bộ danh sách sản phẩm.
  Future<List<Product>> getAllProducts();

  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> removeOrder(Order order);
  Future<List<Order>> getAllOrders();

  Future<void> addOrderItem(OrderItem orderItem);
  Future<void> updateOrderItem(OrderItem orderItem);
  Future<void> removeOrderItem(OrderItem orderItem);
  Future<List<OrderItem>> getAllOrderItems();

  Future<int> getTotalProductCount();
  Future<List<Product>> getFiveLowStockProducts();
  Future<List<Product>> getFiveHighestSalesProducts();
  Future<int> getDailyOrderCount(DateTime date);
  Future<int> getDailyRevenue(DateTime date);
  Future<List<int>> getMonthlyRevenues(DateTime date);
  Future<(Map<Order, List<OrderItem>>, Map<Order, List<Product>>)>
      getThreeRecentOrders();
}
