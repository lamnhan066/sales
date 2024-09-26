import 'package:flutter/material.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:string_normalizer/string_normalizer.dart';

import 'database.dart';

class TestDatabase extends Database {
  final _categories = <Category>[];
  final _products = <Product>[];
  final _orderItems = <OrderItem>[];
  final _orders = <Order>[];

  @override
  Future<void> initial() async {
    _categories.addAll([
      Category(id: 0, name: 'Thức uống', description: 'Thức uống'),
      Category(id: 1, name: 'Thức ăn', description: 'Thức ăn'),
      Category(id: 2, name: 'Gia dụng', description: 'Gia dụng'),
    ]);
    _products.addAll([
      Product(
        id: 0,
        sku: 'P00000001',
        name: 'Cafe',
        imagePath: [],
        importPrice: 10000,
        count: 2,
        description: 'Cafe Cafe',
        categoryId: 0,
      ),
      Product(
        id: 1,
        sku: 'P00000001',
        name: 'Trà',
        imagePath: [],
        importPrice: 10000,
        count: 20,
        description: 'Trà Trà',
        categoryId: 0,
      ),
      Product(
        id: 2,
        sku: 'P00000002',
        name: 'Cơm',
        imagePath: [],
        importPrice: 10000,
        count: 3,
        description: 'Cơm Cơm',
        categoryId: 1,
      ),
      Product(
        id: 3,
        sku: 'P00000003',
        name: 'Chổi',
        imagePath: [],
        importPrice: 10000,
        count: 20,
        description: 'Chổi Chổi',
        categoryId: 2,
      ),
    ]);
    _orderItems.addAll([
      OrderItem(
        id: 0,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 0,
        orderId: 0,
      ),
      OrderItem(
        id: 1,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 1,
        orderId: 0,
      ),
      OrderItem(
        id: 2,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 2,
        orderId: 0,
      ),
      OrderItem(
        id: 3,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 1,
        orderId: 1,
      ),
      OrderItem(
        id: 4,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 2,
        orderId: 1,
      ),
    ]);
    _orders.addAll([
      Order(
        id: 0,
        status: OrderStatus.paid,
        date: DateTime.now(),
        deleted: false,
      ),
      Order(
        id: 1,
        status: OrderStatus.paid,
        date: DateTime.now().subtract(const Duration(days: 1)),
        deleted: false,
      ),
    ]);
  }

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
