import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/services/utils.dart';
import 'package:string_normalizer/string_normalizer.dart';

abstract class Database {
  static Future<(List<Category>, List<Product>)> loadDataFromExcel() async {
    final excel = await Utils.getExcelFile();
    if (excel == null) {
      throw UnsupportedError('Unsupported file');
    }

    final firstSheet = excel.tables.entries.first.value;
    final products = <Product>[];
    final categories = <Category>[];
    for (int i = 1; i < firstSheet.maxRows; i++) {
      final row = firstSheet.rows.elementAt(i);
      final categoryName = '${row.elementAt(6)!.value}';
      Category category;
      try {
        category = categories.singleWhere((e) => e.name == categoryName);
      } catch (_) {
        category = Category(
            id: categories.length, name: categoryName, description: '');
        categories.add(category);
      }
      products.add(
        Product(
          id: i,
          sku: '${row.elementAt(0)!.value}',
          name: '${row.elementAt(1)!.value}',
          imagePath: jsonDecode('${row.elementAt(2)!.value}').cast<String>(),
          importPrice: int.parse('${row.elementAt(3)!.value}'),
          count: int.parse('${row.elementAt(4)!.value}'),
          description: '${row.elementAt(5)!.value}',
          categoryId: category.id,
          deleted: bool.parse('${row.elementAt(7)!.value}'),
        ),
      );
    }
    return (categories, products);
  }

  final _categories = <Category>[];
  final _products = <Product>[];
  final _orderItems = <OrderItem>[];
  final _orders = <Order>[];

  /// Khởi tạo.
  Future<void> initial() async {
    _categories.addAll(await getAllCategories());
    _products.addAll(await getAllProducts());
    _orderItems.addAll(await getAllOrderItems());
    _orders.addAll(await getAllOrders());
  }

  /// Xoá tất cả các dữ liệu.
  @mustCallSuper
  Future<void> clear() async {
    _products.clear();
    _categories.clear();
    _orders.clear();
    _orderItems.clear();
  }

  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  Future<void> merge(List<Category> categories, List<Product> products) async {
    final tempCategories = await getAllCategories();
    final cIndex = tempCategories.length;
    for (int i = 0; i < categories.length; i++) {
      final c = categories.elementAt(i).copyWith(id: cIndex + i);
      tempCategories.add(c);
    }
    await saveAllCategories(tempCategories);

    final tempProducts = await getAllProducts();
    final pIndex = tempProducts.length;
    for (int i = 0; i < products.length; i++) {
      final newIndex = pIndex + i;
      final p = products.elementAt(i).copyWith(
            id: newIndex,
            sku: 'P${newIndex.toString().padLeft(8, '0')}',
          );
      tempProducts.add(p);
    }
    await saveAllProducts(tempProducts);
  }

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  Future<void> replace(
      List<Category> categories, List<Product> products) async {
    await saveAllCategories(categories);
    await saveAllProducts(products);
  }

  /// Thêm loại hàng mới.
  @mustCallSuper
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  /// Sửa và cập nhật loại hàng,
  @mustCallSuper
  Future<void> updateCategory(Category category) async {
    final i = _categories.indexWhere((item) => item.id == category.id);
    _categories[i] = category;
  }

  /// Xoá loại hàng.
  Future<void> removeCategory(Category category) async {
    category = category.copyWith(deleted: true);
    await updateCategory(category);
  }

  /// Lấy danh sách tất cả các loại hàng.
  Future<List<Category>> getAllCategories() async => _categories;

  /// Lưu tất cả loại hàng vào CSDL.
  @mustCallSuper
  Future<void> saveAllCategories(List<Category> categories) async {
    _categories.clear();
    _categories.addAll(categories);
  }

  /// Trình tạo ra `id` và `sku`.
  Future<(int id, String sku)> generateProductIdSku() async {
    final count = await getTotalProductCount();
    final id = count + 1;
    return (id, 'P${id.toString().padLeft(8, '0')}');
  }

  /// Thêm sản phẩm mới.
  @mustCallSuper
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  /// Cập nhật sản phẩm.
  @mustCallSuper
  Future<void> updateProduct(Product product) async {
    final i = _products.indexWhere((item) => item.id == product.id);
    _products[i] = product;
  }

  /// Xoá sản phẩm.
  Future<void> removeProduct(Product product) async {
    product = product.copyWith(deleted: true);
    await updateProduct(product);
  }

  /// Lưu tất cả sản phẩm vào CSDL.
  @mustCallSuper
  Future<void> saveAllProducts(List<Product> products) async {
    _products.clear();
    _products.addAll(products);
  }

  /// Lấy danh sách sản phẩm.
  ///
  /// Lấy danh sách sản phẩm theo điều kiện và trả về (tổng số trang, danh sách
  /// sản phẩm trang hiện tại).
  Future<(int, List<Product>)> getProducts({
    int page = 1,
    int perpage = 10,
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
  }) async {
    List<Product> result = await getAllProducts(
      orderBy: orderBy,
      searchText: searchText,
      rangeValues: rangeValues,
    );
    return (
      result.length,
      result.skip((page - 1) * perpage).take(perpage).toList()
    );
  }

  /// Lấy toàn bộ danh sách sản phẩm.
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
  }) async {
    // Tạo một bản sao chép từ `_products`.
    List<Product> result = [..._products.where((e) => e.deleted == false)];

    if (rangeValues != null) {
      result.removeWhere((product) =>
          product.importPrice < rangeValues.start ||
          product.importPrice > rangeValues.end);
    }

    if (searchText != '') {
      // Xoá dấu.
      searchText = searchText.normalize().toLowerCase();
      result.removeWhere((p) => !p.name.nml.toLowerCase().contains(searchText));
    }

    switch (orderBy) {
      case ProductOrderBy.none:
        break;
      case ProductOrderBy.nameInc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case ProductOrderBy.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
      case ProductOrderBy.importPriceInc:
        result.sort((a, b) => a.importPrice.compareTo(b.importPrice));
      case ProductOrderBy.importPriceDesc:
        result.sort((a, b) => b.importPrice.compareTo(a.importPrice));
      case ProductOrderBy.countInc:
        result.sort((a, b) => a.count.compareTo(b.count));
      case ProductOrderBy.countDesc:
        result.sort((a, b) => b.count.compareTo(a.count));
    }

    return result;
  }

  /// Thêm đơn đặt hàng.
  @mustCallSuper
  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  /// Cập nhật đơn đặt hàng.
  @mustCallSuper
  Future<void> updateOrder(Order order) async {
    final i = _orders.indexWhere((item) => item.id == order.id);
    _orders[i] = order;
  }

  /// Xoá đơn đặt hàng.
  Future<void> removeOrder(Order order) async {
    order = order.copyWith(deleted: true);
    await updateOrder(order);
  }

  /// Lấy danh sách tất cả các đơn hàng.
  Future<List<Order>> getAllOrders() async => _orders;

  /// Lưu tất cả các đơn đặt đặt hàng.
  @mustCallSuper
  Future<void> saveAllOrders(List<Order> orders) async {
    _orders.clear();
    _orders.addAll(orders);
  }

  /// Thêm sản phẩm đã đặt hàng.
  @mustCallSuper
  Future<void> addOrderItem(OrderItem orderItem) async {
    _orderItems.add(orderItem);
  }

  /// Cập nhật sản phẩm đã đặt hàng.
  @mustCallSuper
  Future<void> updateOrderItem(OrderItem orderItem) async {
    final i = _orderItems.indexWhere((item) => item.id == orderItem.id);
    _orderItems[i] = orderItem;
  }

  /// Xoá sản phẩm đã đặt hàng.
  Future<void> removeOrderItem(OrderItem orderItem) async {
    orderItem = orderItem.copyWith(deleted: true);
    updateOrderItem(orderItem);
  }

  /// Lấy tất tất cả sản phẩm đã đặt hàng.
  Future<List<OrderItem>> getAllOrderItems() async => _orderItems;

  /// Lưu tất cả sản phẩm đã đặt hàng.
  @mustCallSuper
  Future<void> saveAllOrderItems(List<OrderItem> orderItems) async {
    _orderItems.clear();
    _orderItems.addAll(orderItems);
  }

  /// Lấy tổng số lượng sản phẩm có trong CSDL.
  Future<int> getTotalProductCount() async {
    final products = await getAllProducts();
    return products.length;
  }

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  Future<List<Product>> getFiveLowStockProducts() async {
    final products = await getAllProducts();
    final lowStockProducts = products.where((p) => p.count < 5).toList();
    return lowStockProducts.sublist(0, min(lowStockProducts.length, 5));
  }

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  Future<List<Product>> getFiveHighestSalesProducts() async {
    final products = await getAllProducts();
    final orderItems = await getAllOrderItems();
    final orderedProductQuantities = <Product, int>{};
    for (final p in products) {
      for (final orderItem in orderItems) {
        if (orderItem.productId == p.id) {
          orderedProductQuantities.putIfAbsent(p, () => 0);
          orderedProductQuantities[p] =
              orderedProductQuantities[p]! + orderItem.quantity;
        }
      }
    }
    var entries = orderedProductQuantities.entries.toList();
    entries.sort((MapEntry<Product, int> a, MapEntry<Product, int> b) =>
        a.value.compareTo(b.value));

    return Map<Product, int>.fromEntries(entries).keys.toList();
  }

  /// Lấy số lượng đơn đặt hàng hằng ngày.
  Future<int> getDailyOrderCount(DateTime date) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) =>
          o.date.year == date.year &&
          o.date.month == date.month &&
          o.date.day == date.day,
    );
    return dailyOrders.length;
  }

  /// Lấy tổng doanh thu hằng ngày.
  Future<int> getDailyRevenue(DateTime date) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) =>
          o.date.year == date.year &&
          o.date.month == date.month &&
          o.date.day == date.day,
    );
    final orderItems = await getAllOrderItems();
    int revenue = 0;
    for (final item in orderItems) {
      for (final order in dailyOrders) {
        if (item.orderId == order.id) {
          revenue += item.totalPrice;
        }
      }
    }
    return revenue;
  }

  /// Lấy tổng doanh thu tháng theo từng ngày.
  ///
  /// Trả về danh sách doanh thu theo ngày từ ngày 1 đến cuối tháng (hoặc đến
  /// ngày hiện tại đối với tháng hiện tại).
  Future<List<int>> getMonthlyRevenues(DateTime date) async {
    final orders = await getAllOrders();
    final monthlyOrders = orders.where(
      (o) => o.date.year == date.year && o.date.month == date.month,
    );
    final orderItems = await getAllOrderItems();
    final revenues = <int>[];

    final now = DateTime.now();
    for (int i = 1; i <= 31; i++) {
      if (DateTime(date.year, date.month, i).isAfter(now)) {
        break;
      }

      int revenue = 0;
      final dailyOrders = monthlyOrders.where((order) => order.date.day == i);
      for (final order in dailyOrders) {
        for (final item in orderItems) {
          if (item.orderId == order.id) {
            revenue += item.totalPrice;
          }
        }
      }
      revenues.add(revenue);
    }
    return revenues;
  }

  /// Lấy danh sách 3 đơn đặt hàng gần đây nhất.
  ///
  /// Trả về danh sách sản phẩm đã đặt hàng và thông tin của đơn đặt hàng.
  Future<(Map<Order, List<OrderItem>>, Map<Order, List<Product>>)>
      getThreeRecentOrders() async {
    final orders = await getAllOrders();
    orders.sort((a, b) => a.date.compareTo(b.date));
    final orderItemMap = <Order, List<OrderItem>>{};
    final orderItems = await getAllOrderItems();
    for (final order in orders.sublist(0, min(orders.length, 3))) {
      orderItemMap.putIfAbsent(order, () => []);
      for (final item in orderItems) {
        if (item.orderId == order.id) {
          orderItemMap[order]!.add(item);
        }
      }
    }
    final productMap = <Order, List<Product>>{};
    final products = await getAllProducts();
    for (final order in orders.sublist(0, min(orders.length, 3))) {
      productMap.putIfAbsent(order, () => []);
      for (final orderItem in orderItemMap[order]!) {
        for (final product in products) {
          if (orderItem.productId == product.id) {
            productMap[order]!.add(product);
          }
        }
      }
    }
    return (orderItemMap, productMap);
  }
}
