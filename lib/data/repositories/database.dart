import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

/// Database abstract.
abstract interface class Database {
  /// Khởi tạo.
  Future<void> initial();

  /// Giải phóng.
  Future<void> dispose();

  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  Future<void> merge(List<CategoryModel> categories, List<ProductModel> products);

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products);

  /// Thêm loại hàng mới.
  Future<void> addCategory(CategoryModel category);

  /// Sửa và cập nhật loại hàng,
  Future<void> updateCategory(CategoryModel category);

  /// Xoá loại hàng.
  Future<void> removeCategory(CategoryModel category);

  /// Lấy danh sách tất cả các loại hàng.
  Future<List<CategoryModel>> getAllCategories();

  /// Lưu tất cả loại hàng vào CSDL.
  Future<void> addAllCategories(List<CategoryModel> categories);

  /// Trình tạo ra `id` và `sku` cho sản phẩm.
  Future<({int id, String sku})> getNextProductIdSku();

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> getNextCategoryId();

  /// Thêm sản phẩm mới.
  Future<void> addProduct(ProductModel product);

  /// Cập nhật sản phẩm.
  Future<void> updateProduct(ProductModel product);

  /// Xoá sản phẩm.
  Future<void> removeProduct(ProductModel product);

  /// Lưu tất cả sản phẩm vào CSDL.
  Future<void> addAllProducts(List<ProductModel> products);

  /// Lấy sản phẩm thông qua ID.
  Future<ProductModel> getProductById(int id);

  /// Lấy danh sách sản phẩm.
  ///
  /// Lấy danh sách sản phẩm theo điều kiện và trả về (tổng số trang, danh sách
  /// sản phẩm trang hiện tại).
  Future<GetResult<ProductModel>> getProducts([GetProductParams params]);

  /// Lấy toàn bộ danh sách sản phẩm.
  Future<List<ProductModel>> getAllProducts();

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> getNextOrderId();

  /// Thêm đơn đặt hàng.
  Future<void> addOrder(OrderModel order);

  /// Cập nhật đơn đặt hàng.
  Future<void> updateOrder(OrderModel order);

  /// Xoá đơn đặt hàng.
  Future<void> removeOrder(OrderModel order);

  /// Lấy danh sách tất cả các đơn hàng.
  Future<List<OrderModel>> getAllOrders();

  /// Lấy danh sách đơn hàng theo điều kiện.
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params]);

  /// Lưu tất cả các đơn đặt đặt hàng.
  Future<void> addAllOrders(List<OrderModel> orders);

  /// Trình tạo ra `id` cho chi tiết đơn hàng.
  Future<int> getNextOrderItemId();

  /// Thêm chi tiết sản phẩm đã đặt hàng.
  Future<void> addOrderItem(OrderItemModel orderItem);

  /// Cập nhật chi tiết sản phẩm đã đặt hàng.
  Future<void> updateOrderItem(OrderItemModel orderItem);

  /// Xoá chi tiết sản phẩm đã đặt hàng.
  Future<void> removeOrderItem(OrderItemModel orderItem);

  /// Lấy danh sách chi tiết sản phẩm đã đặt theo mã đơn và mã sản phẩm.
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params]);

  /// Lấy tất tất cả sản phẩm đã đặt hàng.
  Future<List<OrderItemModel>> getAllOrderItems();

  /// Lưu tất cả sản phẩm đã đặt hàng.
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems);

  /// Lấy tổng số lượng sản phẩm có trong CSDL.
  Future<int> getTotalProductCount();

  /// Thêm OrderModel cùng với OrderItems
  Future<void> addOrderWithOrderItems(OrderWithItemsParams<OrderModel, OrderItemModel> params);

  /// Cập nhật OrderModel cùng với OrderItems
  Future<void> updateOrderWithItems(OrderWithItemsParams<OrderModel, OrderItemModel> params);

  /// Xoá OrderModel cùng với OrderItems
  Future<void> removeOrderWithItems(OrderModel order);

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  Future<List<ProductModel>> getFiveLowStockProducts();

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  Future<Map<ProductModel, int>> getFiveHighestSalesProducts();

  /// Lấy số lượng đơn đặt hàng hằng ngày.
  Future<int> getDailyOrderCount(DateTime dateTime);

  /// Lấy tổng doanh thu hằng ngày.
  Future<int> getDailyRevenue(DateTime dateTime);

  /// Lấy tổng doanh thu tháng theo từng ngày.
  ///
  /// Trả về danh sách doanh thu theo ngày từ ngày 1 đến cuối tháng (hoặc đến
  /// ngày hiện tại đối với tháng hiện tại).
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime);

  /// Lấy danh sách 3 đơn đặt hàng gần đây nhất.
  ///
  /// Trả về danh sách sản phẩm đã đặt hàng và thông tin của đơn đặt hàng.
  Future<RecentOrdersResultModel> getThreeRecentOrders();
}
