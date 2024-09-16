import 'dart:math';

import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';

import 'database.dart';

class TestDatabase implements Database {
  final _categories = <Category>[
    Category(id: 0, name: 'Thức uống', description: 'Thức uống'),
    Category(id: 1, name: 'Thức ăn', description: 'Thức ăn'),
    Category(id: 2, name: 'Gia dụng', description: 'Gia dụng'),
  ];
  final _products = <Product>[
    Product(
      id: 0,
      sku: 'P00000001',
      name: 'Cafe',
      importPrice: 10000,
      count: 2,
      description: 'Cafe Cafe',
      categoryId: 0,
    ),
    Product(
      id: 1,
      sku: 'P00000001',
      name: 'Trà',
      importPrice: 10000,
      count: 20,
      description: 'Trà Trà',
      categoryId: 0,
    ),
    Product(
      id: 2,
      sku: 'P00000002',
      name: 'Cơm',
      importPrice: 10000,
      count: 3,
      description: 'Cơm Cơm',
      categoryId: 1,
    ),
    Product(
      id: 3,
      sku: 'P00000003',
      name: 'Chổi',
      importPrice: 10000,
      count: 20,
      description: 'Chổi Chổi',
      categoryId: 2,
    ),
  ];
  final _orderItems = <OrderItem>[
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
  ];
  final _orders = <Order>[
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
  ];

  @override
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  @override
  Future<void> addOrderItem(OrderItem orderItem) async {
    _orderItems.add(orderItem);
  }

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<List<Category>> getCategories() async {
    return _categories;
  }

  @override
  Future<List<OrderItem>> getOrderItems() async {
    return _orderItems;
  }

  @override
  Future<List<Order>> getOrders() async {
    return _orders;
  }

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }

  @override
  Future<void> removeCategory(Category category) async {
    _categories.remove(category);
  }

  @override
  Future<void> removeOrder(Order order) async {
    _orders.remove(order);
  }

  @override
  Future<void> removeOrderItem(OrderItem orderItem) async {
    _orderItems.remove(orderItem);
  }

  @override
  Future<void> removeProduct(Product product) async {
    _products.remove(product);
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
    final orders = await getOrders();
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
    final orders = await getOrders();
    final dailyOrders = orders.where(
      (o) =>
          o.date.year == date.year &&
          o.date.month == date.month &&
          o.date.day == date.day,
    );
    final orderItems = await getOrderItems();
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
    final products = await getProducts();
    final orderItems = await getOrderItems();
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
    final products = await getProducts();
    final lowStockProducts = products.where((p) => p.count < 5).toList();
    return lowStockProducts.sublist(0, min(lowStockProducts.length, 5));
  }

  @override
  Future<(Map<Order, List<OrderItem>>, Map<Order, List<Product>>)>
      getThreeRecentOrders() async {
    final orders = await getOrders();
    orders.sort((a, b) => a.date.compareTo(b.date));
    final orderItemMap = <Order, List<OrderItem>>{};
    final orderItems = await getOrderItems();
    for (final order in orders.sublist(0, min(orders.length, 3))) {
      orderItemMap.putIfAbsent(order, () => []);
      for (final item in orderItems) {
        if (item.orderId == order.id) {
          orderItemMap[order]!.add(item);
        }
      }
    }
    final productMap = <Order, List<Product>>{};
    final products = await getProducts();
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
    final products = await getProducts();
    return products.length;
  }

  @override
  Future<List<int>> getMonthlyRevenues(DateTime date) async {
    final orders = await getOrders();
    final monthlyOrders = orders.where(
      (o) => o.date.year == date.year && o.date.month == date.month,
    );
    final orderItems = await getOrderItems();
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
}
