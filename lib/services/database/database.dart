import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/services/utils.dart';

abstract interface class Database {
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

  Future<void> initial();

  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> removeCategory(Category category);
  Future<List<Category>> getAllCategories();
  Future<void> saveAllCategories(List<Category> categories);

  Future<(int id, String sku)> generateProductIdSku();
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> removeProduct(Product product);
  Future<void> saveAllProducts(List<Product> products);

  /// Lấy danh sách sản phẩm.
  ///
  /// Lấy danh sách sản phẩm theo điều kiện và trả về (tổng số trang, danh sách sản phẩm trang hiện tại).
  Future<(int, List<Product>)> getProducts({
    int page = 1,
    int perpage = 10,
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
  });

  /// Lấy toàn bộ danh sách sản phẩm.
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
  });

  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> removeOrder(Order order);
  Future<List<Order>> getAllOrders();
  Future<void> saveAllOrders(List<Order> orders);

  Future<void> addOrderItem(OrderItem orderItem);
  Future<void> updateOrderItem(OrderItem orderItem);
  Future<void> removeOrderItem(OrderItem orderItem);
  Future<List<OrderItem>> getAllOrderItems();
  Future<void> saveAllOrderItems(List<OrderItem> orderItems);

  Future<int> getTotalProductCount();
  Future<List<Product>> getFiveLowStockProducts();
  Future<List<Product>> getFiveHighestSalesProducts();
  Future<int> getDailyOrderCount(DateTime date);
  Future<int> getDailyRevenue(DateTime date);
  Future<List<int>> getMonthlyRevenues(DateTime date);
  Future<(Map<Order, List<OrderItem>>, Map<Order, List<Product>>)>
      getThreeRecentOrders();
}
