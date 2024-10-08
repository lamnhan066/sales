import 'dart:convert';

import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/recent_orders_result.dart';
import 'package:sales/infrastucture/utils/excel_picker.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/range_of_dates.dart';

/// Database abstract.
abstract interface class Database {
  /// Load dữ liệu từ Excel.
  static Future<({List<Category> categories, List<Product> products})?> loadDataFromExcel() async {
    final excel = await ExcelPicker.getExcelFile();
    if (excel == null) {
      return null;
    }

    final firstSheet = excel.tables.entries.first.value;
    final products = <Product>[];
    final categories = <Category>[];
    for (int i = 1; i < firstSheet.maxRows; i++) {
      final row = firstSheet.rows.elementAt(i);
      final categoryName = '${row.elementAt(6)?.value}';
      Category category;
      try {
        category = categories.singleWhere((e) => e.name == categoryName);
      } catch (_) {
        category = Category(
          id: categories.length,
          name: categoryName,
          description: '',
        );
        categories.add(category);
      }
      products.add(
        Product(
          id: i,
          sku: '${row.first?.value}',
          name: '${row.elementAt(1)?.value}',
          imagePath: (jsonDecode('${row.elementAt(2)?.value}') as List<dynamic>).cast<String>(),
          importPrice: int.parse('${row.elementAt(3)?.value}'),
          count: int.parse('${row.elementAt(4)?.value}'),
          description: '${row.elementAt(5)?.value}',
          categoryId: category.id,
          deleted: bool.parse('${row.elementAt(7)?.value}'),
        ),
      );
    }

    return (categories: categories, products: products);
  }

  /// Khởi tạo.
  Future<void> initial();

  /// Giải phóng.
  Future<void> dispose();

  /// Xoá tất cả các dữ liệu.
  Future<void> clear();

  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  Future<void> merge(List<Category> categories, List<Product> products);

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replace(List<Category> categories, List<Product> products);

  /// Thêm loại hàng mới.
  Future<void> addCategory(Category category);

  /// Sửa và cập nhật loại hàng,
  Future<void> updateCategory(Category category);

  /// Xoá loại hàng.
  Future<void> removeCategory(Category category);

  /// Lấy danh sách tất cả các loại hàng.
  Future<List<Category>> getAllCategories();

  /// Lưu tất cả loại hàng vào CSDL.
  Future<void> addAllCategories(List<Category> categories);

  /// Xoá tất cả loại hàng.
  Future<void> removeAllCategories();

  /// Trình tạo ra `id` và `sku` cho sản phẩm.
  Future<({int id, String sku})> generateProductIdSku();

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> getNextCategoryId();

  /// Thêm sản phẩm mới.
  Future<void> addProduct(Product product);

  /// Cập nhật sản phẩm.
  Future<void> updateProduct(Product product);

  /// Xoá sản phẩm.
  Future<void> removeProduct(Product product);

  /// Lưu tất cả sản phẩm vào CSDL.
  Future<void> addAllProducts(List<Product> products);

  /// Xoá tất cả sản phẩm.
  Future<void> removeAllProducts();

  /// Lấy sản phẩm thông qua ID.
  Future<Product> getProductById(int id);

  /// Lấy danh sách sản phẩm.
  ///
  /// Lấy danh sách sản phẩm theo điều kiện và trả về (tổng số trang, danh sách
  /// sản phẩm trang hiện tại).
  Future<({int totalCount, List<Product> products})> getProducts([GetProductParams params = const GetProductParams()]);

  /// Lấy toàn bộ danh sách sản phẩm.
  Future<List<Product>> getAllProducts([GetProductParams params = const GetProductParams()]);

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> generateOrderId();

  /// Thêm đơn đặt hàng.
  Future<void> addOrder(Order order);

  /// Cập nhật đơn đặt hàng.
  Future<void> updateOrder(Order order);

  /// Xoá đơn đặt hàng.
  Future<void> removeOrder(Order order);

  /// Lấy danh sách tất cả các đơn hàng.
  Future<List<Order>> getAllOrders({RangeOfDates? dateRange});

  /// Lấy danh sách đơn hàng theo điều kiện.
  Future<({int totalCount, List<Order> orders})> getOrders({
    int page = 1,
    int perpage = 10,
    RangeOfDates? dateRange,
  });

  /// Lưu tất cả các đơn đặt đặt hàng.
  Future<void> saveAllOrders(List<Order> orders);

  /// Trình tạo ra `id` cho chi tiết đơn hàng.
  Future<int> generateOrderItemId();

  /// Thêm chi tiết sản phẩm đã đặt hàng.
  Future<void> addOrderItem(OrderItem orderItem);

  /// Cập nhật chi tiết sản phẩm đã đặt hàng.
  Future<void> updateOrderItem(OrderItem orderItem);

  /// Xoá chi tiết sản phẩm đã đặt hàng.
  Future<void> removeOrderItem(OrderItem orderItem);

  /// Lấy danh sách chi tiết sản phẩm đã đặt theo mã đơn và mã sản phẩm.
  Future<List<OrderItem>> getOrderItems({int? orderId, int? productId});

  /// Lấy tất tất cả sản phẩm đã đặt hàng.
  Future<List<OrderItem>> getAllOrderItems({int? orderId, int? productId});

  /// Lưu tất cả sản phẩm đã đặt hàng.
  Future<void> saveAllOrderItems(List<OrderItem> orderItems);

  /// Lấy tổng số lượng sản phẩm có trong CSDL.
  Future<int> getTotalProductCount();

  /// Thêm Order cùng với OrderItems
  Future<void> addOrderWithOrderItems(Order order, List<OrderItem> orderItems);

  /// Cập nhật Order cùng với OrderItems
  Future<void> updateOrderWithOrderItems(Order order, List<OrderItem> orderItems);

  /// Xoá Order cùng với OrderItems
  Future<void> removeOrderWithOrderItems(Order order);

  /// Xoá tất cả đơn đặt hàng cùng với chi tiết đơn hàng tương ứng.
  Future<void> removeAllOrdersWithOrderItems();

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  Future<List<Product>> getFiveLowStockProducts();

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  Future<List<Product>> getFiveHighestSalesProducts();

  /// Lấy số lượng đơn đặt hàng hằng ngày.
  Future<int> getDailyOrderCount(DateTime dateTime);

  /// Lấy tổng doanh thu hằng ngày.
  Future<int> getDailyRevenue(DateTime dateTime);

  /// Lấy tổng doanh thu tháng theo từng ngày.
  ///
  /// Trả về danh sách doanh thu theo ngày từ ngày 1 đến cuối tháng (hoặc đến
  /// ngày hiện tại đối với tháng hiện tại).
  Future<List<int>> getMonthlyRevenues(DateTime dateTime);

  /// Lấy danh sách 3 đơn đặt hàng gần đây nhất.
  ///
  /// Trả về danh sách sản phẩm đã đặt hàng và thông tin của đơn đặt hàng.
  Future<RecentOrdersResult> getThreeRecentOrders();
}
