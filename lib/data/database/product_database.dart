import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';

abstract interface class ProductDatabase {
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

  /// Lấy toàn bộ danh sách sản phẩm kể cả sản phẩm đã bị xoá.
  Future<List<ProductModel>> getAllProducts();

  /// Trình tạo ra `id` và `sku` cho sản phẩm.
  Future<({int id, String sku})> getNextProductIdSku();

  /// Lấy tổng số lượng sản phẩm có trong CSDL.
  Future<int> getTotalProductCount();
}
