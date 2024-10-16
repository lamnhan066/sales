import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/temporary_data_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemporaryDataRepositoryImpl implements TemporaryDataRepository {
  final SharedPreferences _prefs;

  const TemporaryDataRepositoryImpl(this._prefs);

  @override
  Future<OrderWithItemsParams?> getOrder() async {
    final data = _prefs.getString('TemporaryOrderWithItems');
    if (data == null) {
      return null;
    }
    return OrderWithItemsParams.fromJson(data);
  }

  @override
  Future<Product?> getProduct() async {
    final data = _prefs.getString('TemporaryProduct');
    if (data == null) {
      return null;
    }
    return Product.fromJson(data);
  }

  @override
  Future<void> saveOrder(OrderWithItemsParams params) async {
    await _prefs.setString('TemporaryOrderWithItems', params.toJson());
  }

  @override
  Future<void> saveProduct(Product product) async {
    await _prefs.setString('TemporaryProduct', product.toJson());
  }

  @override
  Future<void> removeOrder() async {
    await _prefs.remove('TemporaryOrderWithItems');
  }

  @override
  Future<void> removeProduct() async {
    await _prefs.remove('TemporaryProduct');
  }
}
