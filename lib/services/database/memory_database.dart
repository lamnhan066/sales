import 'package:flutter/material.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'database.dart';

class MemoryDatabase extends Database {
  final _categories = <Category>[];
  final _products = <Product>[];
  final _orderItems = <OrderItem>[];
  final _orders = <Order>[];

  @override
  Future<void> initial() async {}

  @override
  Future<void> clear() async {
    _products.clear();
    _categories.clear();
    _orders.clear();
    _orderItems.clear();
  }

  @override
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final i = _categories.indexWhere((item) => item.id == category.id);
    _categories[i] = category;
  }

  @override
  Future<List<Category>> getAllCategories() async => _categories;

  @override
  Future<void> saveAllCategories(List<Category> categories) async {
    _categories.clear();
    _categories.addAll(categories);
  }

  @override
  Future<(int id, String sku)> generateProductIdSku() async {
    final count = await getTotalProductCount();
    final id = count + 1;
    return (id, 'P${id.toString().padLeft(8, '0')}');
  }

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final i = _products.indexWhere((item) => item.id == product.id);
    _products[i] = product;
  }

  @override
  Future<void> saveAllProducts(List<Product> products) async {
    _products.clear();
    _products.addAll(products);
  }

  @override
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

  @override
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
    int? categoryId,
  }) async {
    final result = _products.where((product) {
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
  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  @override
  Future<void> updateOrder(Order order) async {
    final i = _orders.indexWhere((item) => item.id == order.id);
    _orders[i] = order;
  }

  @override
  Future<void> removeOrder(Order order) async {
    order = order.copyWith(deleted: true);
    await updateOrder(order);
  }

  @override
  Future<List<Order>> getAllOrders() async => _orders;

  @override
  Future<void> saveAllOrders(List<Order> orders) async {
    _orders.clear();
    _orders.addAll(orders);
  }

  @override
  Future<void> addOrderItem(OrderItem orderItem) async {
    _orderItems.add(orderItem);
  }

  @override
  Future<void> updateOrderItem(OrderItem orderItem) async {
    final i = _orderItems.indexWhere((item) => item.id == orderItem.id);
    _orderItems[i] = orderItem;
  }

  @override
  Future<void> removeOrderItem(OrderItem orderItem) async {
    orderItem = orderItem.copyWith(deleted: true);
    updateOrderItem(orderItem);
  }

  @override
  Future<List<OrderItem>> getAllOrderItems() async => _orderItems;

  @override
  Future<void> saveAllOrderItems(List<OrderItem> orderItems) async {
    _orderItems.clear();
    _orderItems.addAll(orderItems);
  }
}
