import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';

import 'database.dart';

class TestDatabase extends Database {
  @override
  Future<void> initial() async {
    final categories = [
      Category(id: 0, name: 'Thức uống', description: 'Thức uống'),
      Category(id: 1, name: 'Thức ăn', description: 'Thức ăn'),
      Category(id: 2, name: 'Gia dụng', description: 'Gia dụng'),
    ];
    for (final category in categories) {
      await addCategory(category);
    }

    final products = [
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
    ];
    for (final product in products) {
      await addProduct(product);
    }

    final orderItems = [
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
    for (final orderItem in orderItems) {
      await addOrderItem(orderItem);
    }

    final orders = [
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
    for (final order in orders) {
      await addOrder(order);
    }
  }
}
