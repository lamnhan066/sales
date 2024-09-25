import 'dart:math';

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

class LocalDatabase implements Database {
  final _pref = getIt<SharedPreferences>();
  final _categories = <Category>[];
  final _products = <Product>[];
  final _orderItems = <OrderItem>[];
  final _orders = <Order>[];

  @override
  Future<void> initial() async {
    _categories.addAll(await getAllCategories());
    _products.addAll(await getAllProducts());
    _orderItems.addAll(await getAllOrderItems());
    _orders.addAll(await getAllOrders());
  }

  @override
  Future<void> addCategory(Category category) async {
    final categories = await getAllCategories();
    categories.add(category);
    await saveAllCategories(categories);
    _categories.add(category);
  }

  @override
  Future<void> addOrder(Order order) async {
    final orders = await getAllOrders();
    orders.add(order);
    await saveAllOrders(orders);
    _orders.add(order);
  }

  @override
  Future<void> addOrderItem(OrderItem orderItem) async {
    final orderItems = await getAllOrderItems();
    orderItems.add(orderItem);
    await saveAllOrderItems(orderItems);
    _orderItems.add(orderItem);
  }

  @override
  Future<void> addProduct(Product product) async {
    final products = await getAllProducts();
    products.add(product);
    await saveAllProducts(products);
    _products.add(product);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final categoriesJson = _pref.getStringList('Categories') ?? [];
    final categories = <Category>[];
    if (categoriesJson.isNotEmpty) {
      for (final category in categoriesJson) {
        categories.add(Category.fromJson(category));
      }
    }
    return categories;
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
  Future<(int, String)> generateProductIdSku() async {
    final id = _products.last.id + 1;
    return (_products.last.id + 1, 'P${id.toString().padLeft(8, '0')}');
  }

  @override
  Future<(int, List<Product>)> getProducts({
    int page = 1,
    int perpage = 10,
    ProductOrderBy orderBy = ProductOrderBy.nameInc,
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

  @override
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
  }) async {
    List<Product> result = [];

    final productsJson = _pref.getStringList('Products') ?? [];
    if (productsJson.isNotEmpty) {
      for (final productJson in productsJson) {
        final product = Product.fromJson(productJson);
        if (!product.deleted) {
          result.add(product);
        }
      }
    }

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

  @override
  Future<void> removeCategory(Category category) async {
    category = category.copyWith(deleted: true);
    updateCategory(category);
  }

  @override
  Future<void> removeOrder(Order order) async {
    order = order.copyWith(deleted: true);
    updateOrder(order);
  }

  @override
  Future<void> removeOrderItem(OrderItem orderItem) async {
    orderItem = orderItem.copyWith(deleted: true);
    updateOrderItem(orderItem);
  }

  @override
  Future<void> removeProduct(Product product) async {
    product = product.copyWith(deleted: true);
    updateProduct(product);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final i = _categories.indexWhere((item) => item.id == category.id);
    _categories[i] = category;
  }

  @override
  Future<void> updateOrder(Order order) async {
    final i = _orders.indexWhere((item) => item.id == order.id);
    _orders[i] = order;
  }

  @override
  Future<void> updateOrderItem(OrderItem orderItem) async {
    final i = _orderItems.indexWhere((item) => item.id == orderItem.id);
    _orderItems[i] = orderItem;
  }

  @override
  Future<void> updateProduct(Product product) async {
    final i = _products.indexWhere((item) => item.id == product.id);
    _products[i] = product;
  }

  @override
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

  @override
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

  @override
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

  @override
  Future<List<Product>> getFiveLowStockProducts() async {
    final products = await getAllProducts();
    final lowStockProducts = products.where((p) => p.count < 5).toList();
    return lowStockProducts.sublist(0, min(lowStockProducts.length, 5));
  }

  @override
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

  @override
  Future<int> getTotalProductCount() async {
    final products = await getAllProducts();
    return products.length;
  }

  @override
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
