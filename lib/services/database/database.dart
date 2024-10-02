import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/models/range_of_dates.dart';
import 'package:sales/services/utils.dart';

abstract class Database {
  /// Load dữ liệu từ Excel.
  static Future<(List<Category>, List<Product>)?> loadDataFromExcel() async {
    final excel = await Utils.getExcelFile();
    if (excel == null) {
      return null;
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
          id: categories.length,
          name: categoryName,
          description: '',
        );
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

  /// Khởi tạo.
  Future<void> initial();

  /// Xoá tất cả các dữ liệu.
  Future<void> clear();

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
  Future<void> addCategory(Category category);

  /// Sửa và cập nhật loại hàng,
  Future<void> updateCategory(Category category);

  /// Xoá loại hàng.
  Future<void> removeCategory(Category category) async {
    category = category.copyWith(deleted: true);
    await updateCategory(category);
  }

  /// Lấy danh sách tất cả các loại hàng.
  Future<List<Category>> getAllCategories();

  /// Lưu tất cả loại hàng vào CSDL.
  Future<void> saveAllCategories(List<Category> categories);

  /// Trình tạo ra `id` và `sku` cho sản phẩm.
  Future<(int id, String sku)> generateProductIdSku() async {
    final count = await getTotalProductCount();
    final id = count + 1;
    return (id, 'P${id.toString().padLeft(8, '0')}');
  }

  /// Trình tạo ra `id` cho loại hàng.
  Future<int> generateCategoryId() async {
    final categories = await getAllCategories();
    final count = categories.length;
    final id = count + 1;
    return id;
  }

  /// Thêm sản phẩm mới.
  Future<void> addProduct(Product product);

  /// Cập nhật sản phẩm.
  Future<void> updateProduct(Product product);

  /// Xoá sản phẩm.
  Future<void> removeProduct(Product product) async {
    product = product.copyWith(deleted: true);
    await updateProduct(product);
  }

  /// Lưu tất cả sản phẩm vào CSDL.
  Future<void> saveAllProducts(List<Product> products);

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
    int? categoryId,
  }) async {
    List<Product> result = await getAllProducts(
      orderBy: orderBy,
      searchText: searchText,
      rangeValues: rangeValues,
      categoryId: categoryId,
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
    int? categoryId,
  });

  /// Thêm đơn đặt hàng.
  Future<void> addOrder(Order order);

  /// Cập nhật đơn đặt hàng.
  Future<void> updateOrder(Order order);

  /// Xoá đơn đặt hàng.
  Future<void> removeOrder(Order order) async {
    order = order.copyWith(deleted: true);
    await updateOrder(order);
  }

  /// Lấy danh sách tất cả các đơn hàng.
  Future<List<Order>> getAllOrders({
    RangeOfDates? dateRange,
  });

  /// Lấy danh sách đơn hàng theo điều kiện.
  Future<({int totalCount, List<Order> orders})> getOrders({
    int page = 1,
    int perpage = 10,
    RangeOfDates? dateRange,
  }) async {
    final result = await getAllOrders(dateRange: dateRange);
    return (
      totalCount: result.length,
      orders: result.skip((page - 1) * perpage).take(perpage).toList()
    );
  }

  /// Lưu tất cả các đơn đặt đặt hàng.
  Future<void> saveAllOrders(List<Order> orders);

  /// Thêm sản phẩm đã đặt hàng.
  Future<void> addOrderItem(OrderItem orderItem);

  /// Cập nhật sản phẩm đã đặt hàng.
  Future<void> updateOrderItem(OrderItem orderItem);

  /// Xoá sản phẩm đã đặt hàng.
  Future<void> removeOrderItem(OrderItem orderItem) async {
    orderItem = orderItem.copyWith(deleted: true);
    await updateOrderItem(orderItem);
  }

  /// Lấy tất tất cả sản phẩm đã đặt hàng.
  Future<List<OrderItem>> getAllOrderItems();

  /// Lưu tất cả sản phẩm đã đặt hàng.
  Future<void> saveAllOrderItems(List<OrderItem> orderItems);

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
