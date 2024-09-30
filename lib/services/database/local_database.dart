import 'package:flutter/material.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'database.dart';

class LocalDatabase extends Database {
  final _pref = getIt<SharedPreferences>();

  @override
  Future<void> initial() async {}

  @override
  Future<void> clear() async {
    await _pref.remove('Categories');
    await _pref.remove('Products');
    await _pref.remove('Orders');
    await _pref.remove('OrderItems');
  }

  @override
  Future<void> addCategory(Category category) async {
    final categories = await getAllCategories();
    categories.add(category);
    await saveAllCategories(categories);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categories = await getAllCategories();
    final index = categories.indexWhere((e) => e.id == category.id);
    categories[index] = category;
    await saveAllCategories(categories);
  }

  @override
  Future<void> addOrder(Order order) async {
    final orders = await getAllOrders();
    orders.add(order);
    await saveAllOrders(orders);
  }

  @override
  Future<void> updateOrder(Order order) async {
    final orders = await getAllOrders();
    final index = orders.indexWhere((e) => e.id == order.id);
    orders[index] = order;
    await saveAllOrders(orders);
  }

  @override
  Future<void> addOrderItem(OrderItem orderItem) async {
    final orderItems = await getAllOrderItems();
    orderItems.add(orderItem);
    await saveAllOrderItems(orderItems);
  }

  @override
  Future<void> updateOrderItem(OrderItem orderItem) async {
    final orderItems = await getAllOrderItems();
    final index = orderItems.indexWhere((e) => e.id == orderItem.id);
    orderItems[index] = orderItem;
    await saveAllOrderItems(orderItems);
  }

  @override
  Future<void> addProduct(Product product) async {
    final products = await getAllProducts();
    products.add(product);
    await saveAllProducts(products);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final products = await getAllProducts();
    final index = products.indexWhere((e) => e.id == product.id);
    products[index] = product;
    await saveAllProducts(products);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final categoriesJson = _pref.getStringList('Categories') ?? [];
    return categoriesJson.map((e) => Category.fromJson(e)).where((category) {
      return !category.deleted;
    }).toList();
  }

  @override
  Future<List<OrderItem>> getAllOrderItems() async {
    final orderItems = <OrderItem>[];
    final orderItemJson = _pref.getStringList('OrderItems') ?? [];
    if (orderItemJson.isNotEmpty) {
      for (final orderItem in orderItemJson) {
        orderItems.add(OrderItem.fromJson(orderItem));
      }
    }
    return orderItems;
  }

  @override
  Future<List<Order>> getAllOrders() async {
    final orders = <Order>[];
    final ordersJson = _pref.getStringList('Orders') ?? [];
    if (ordersJson.isNotEmpty) {
      for (final order in ordersJson) {
        orders.add(Order.fromJson(order));
      }
    }
    return orders;
  }

  @override
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
    int? categoryId,
  }) async {
    // Lấy tất cả dữ liệu từ CSDL.
    final productsJson = _pref.getStringList('Products') ?? [];
    final result =
        productsJson.map((e) => Product.fromJson(e)).where((product) {
      // Sản phẩm đã bị xoá.
      if (product.deleted) return false;

      // Lọc theo loại hàng.
      if (categoryId != null && product.categoryId != categoryId) {
        return false;
      }

      // Lọc theo mức giá.
      bool priceFilter = true;
      if (rangeValues != null) {
        priceFilter = product.importPrice >= rangeValues.start &&
            product.importPrice <= rangeValues.end;
      }

      // Tìm kiếm.
      bool search = true;
      if (searchText.isNotEmpty) {
        search = product.name.normalize().toLowerCase().contains(searchText);
      }

      return priceFilter && search;
    }).toList();

    // Sắp xếp.
    switch (orderBy) {
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

    return result;
  }

  @override
  Future<void> saveAllCategories(List<Category> categories) async {
    await _pref.setStringList(
        'Categories', categories.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> saveAllOrderItems(List<OrderItem> orderItems) async {
    await _pref.setStringList(
        'OrderItems', orderItems.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> saveAllOrders(List<Order> orders) async {
    await _pref.setStringList('Orders', orders.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> saveAllProducts(List<Product> products) async {
    await _pref.setStringList(
        'Products', products.map((e) => e.toJson()).toList());
  }
}
