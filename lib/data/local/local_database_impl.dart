import 'package:sales/data/local/database.dart';
import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_normalizer/string_normalizer.dart';

/// Local database.
class LocalDatabaseImpl extends Database {
  final _pref = getIt<SharedPreferences>();

  @override
  Future<void> initial() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> addCategory(CategoryModel category) async {
    final categories = await getAllCategories();
    categories.add(category);
    await addAllCategories(categories);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final categories = await getAllCategories();
    final index = categories.indexWhere((e) => e.id == category.id);
    categories[index] = category;
    await addAllCategories(categories);
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    final orders = await getAllOrders();
    orders.add(order);
    await addAllOrders(orders);
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    final orders = await getAllOrders();
    final index = orders.indexWhere((e) => e.id == order.id);
    orders[index] = order;
    await addAllOrders(orders);
  }

  @override
  Future<void> addOrderItem(OrderItemModel orderItem) async {
    final orderItems = await getAllOrderItems();
    orderItems.add(orderItem);
    await addAllOrderItems(orderItems);
  }

  @override
  Future<void> updateOrderItem(OrderItemModel orderItem) async {
    final orderItems = await getAllOrderItems();
    final index = orderItems.indexWhere((e) => e.id == orderItem.id);
    orderItems[index] = orderItem;
    await addAllOrderItems(orderItems);
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final products = await getAllProducts();
    products.add(product);
    await addAllProducts(products);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final products = await getAllProducts();
    final index = products.indexWhere((e) => e.id == product.id);
    products[index] = product;
    await addAllProducts(products);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final categoriesJson = _pref.getStringList('Categories') ?? [];

    return categoriesJson.map(CategoryModel.fromJson).where((category) {
      return !category.deleted;
    }).toList();
  }

  @override
  Future<List<OrderItemModel>> getAllOrderItems([GetOrderItemsParams? params = const GetOrderItemsParams()]) async {
    final orderItemJson = _pref.getStringList('OrderItems') ?? [];
    final orderItems = orderItemJson.map(OrderItemModel.fromJson);

    return orderItems.where((e) {
      if (e.deleted) return false;

      if (params?.orderId != null && e.orderId != params?.orderId) {
        return false;
      }

      if (params?.productId != null && e.productId != params?.productId) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final ordersJson = _pref.getStringList('Orders') ?? [];
    return ordersJson.map(OrderModel.fromJson).toList();
  }

  @override
  Future<GetResult<ProductModel>> getProducts([GetProductParams params = const GetProductParams()]) async {
    // Lấy tất cả dữ liệu từ CSDL.
    final productsJson = _pref.getStringList('Products') ?? [];
    final result = productsJson.map(ProductModel.fromJson).where((product) {
      // Sản phẩm đã bị xoá.
      if (product.deleted) return false;

      // Lọc theo loại hàng.
      if (params.isUseCategoryFilter && product.categoryId != params.categoryIdFilter) {
        return false;
      }

      // Lọc theo mức giá.
      bool priceFilter = true;
      if (params.isUsePriceRangeFilter) {
        priceFilter = product.importPrice >= params.priceRange.start && product.importPrice <= params.priceRange.end;
      }

      // Tìm kiếm.
      bool search = true;
      if (params.searchText.isNotEmpty) {
        search = product.name.normalize().toLowerCase().contains(params.searchText);
      }

      return priceFilter && search;
    }).toList();

    // Sắp xếp.
    switch (params.orderBy) {
      case ProductOrderBy.none:
        break;
      case ProductOrderBy.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case ProductOrderBy.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
      case ProductOrderBy.importPriceAsc:
        result.sort((a, b) => a.importPrice.compareTo(b.importPrice));
      case ProductOrderBy.importPriceDesc:
        result.sort((a, b) => b.importPrice.compareTo(a.importPrice));
      case ProductOrderBy.countAsc:
        result.sort((a, b) => a.count.compareTo(b.count));
      case ProductOrderBy.countDesc:
        result.sort((a, b) => b.count.compareTo(a.count));
    }

    return GetResult(
      totalCount: result.length,
      items: result.skip((params.page - 1) * params.perPage).take(params.perPage).toList(),
    );
  }

  @override
  Future<void> addAllCategories(List<CategoryModel> categories) async {
    await _pref.setStringList(
      'Categories',
      categories.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems) async {
    await _pref.setStringList(
      'OrderItems',
      orderItems.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<void> addAllOrders(List<OrderModel> orders) async {
    await _pref.setStringList('Orders', orders.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> addAllProducts(List<ProductModel> products) async {
    await _pref.setStringList(
      'Products',
      products.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<void> removeOrderWithItems(OrderModel order) async {
    final orders = await getAllOrders();
    orders.removeWhere((e) => e.id == order.id);
    final items = _pref.getStringList('OrderItems')?.map(OrderItemModel.fromJson).toList() ?? [];
    items.removeWhere((e) => e.orderId == order.id);

    await _pref.setStringList('Orders', orders.map((e) => e.toJson()).toList());
    await _pref.setStringList('OrderItems', items.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return _pref.getStringList('Products')?.map(ProductModel.fromJson).toList() ?? [];
  }

  @override
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    final ordersJson = _pref.getStringList('Orders') ?? [];
    final orders = ordersJson.map(OrderModel.fromJson).where((o) {
      if (o.deleted) return false;

      // Lọc theo ngày
      if (params.dateRange != null &&
          (o.date.isBefore(params.dateRange!.start) || o.date.isAfter(params.dateRange!.end))) {
        return false;
      }

      return true;
    }).toList();

    return GetResult(
      totalCount: orders.length,
      items: orders.skip((params.page - 1) * params.perpage).take(params.perpage).toList(),
    );
  }

  @override
  Future<void> backup(String backupPath) {
    // TODO: implement backup
    throw UnimplementedError();
  }

  @override
  Future<void> restore(String backupPath) {
    // TODO: implement restore
    throw UnimplementedError();
  }
}
