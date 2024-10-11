import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/order_status.dart';
import 'package:sales/infrastructure/database/memory/memory_storage.dart';

/// Database in the memory with sample data.
class SampleMemoryDatabaseImpl extends MemoryStorageImpl {
  @override
  Future<void> initial() async {
    await addAllCategories([
      CategoryModel(id: 0, name: 'Thức uống', description: 'Thức uống'),
      CategoryModel(id: 1, name: 'Thức ăn', description: 'Thức ăn'),
      CategoryModel(id: 2, name: 'Gia dụng', description: 'Gia dụng'),
    ]);
    await addAllProducts([
      ProductModel(
        id: 0,
        sku: 'P00000000',
        name: 'Cafe',
        imagePath: [],
        importPrice: 10000,
        count: 2,
        description: 'Cafe Cafe',
        categoryId: 0,
      ),
      ProductModel(
        id: 1,
        sku: 'P00000001',
        name: 'Trà',
        imagePath: [],
        importPrice: 10000,
        count: 20,
        description: 'Trà Trà',
        categoryId: 0,
      ),
      ProductModel(
        id: 2,
        sku: 'P00000002',
        name: 'Cơm',
        imagePath: [],
        importPrice: 10000,
        count: 3,
        description: 'Cơm Cơm',
        categoryId: 1,
      ),
      ProductModel(
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
    await addAllOrderItems([
      OrderItemModel(
        id: 0,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 0,
        orderId: 0,
      ),
      OrderItemModel(
        id: 1,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 1,
        orderId: 0,
      ),
      OrderItemModel(
        id: 2,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 2,
        orderId: 0,
      ),
      OrderItemModel(
        id: 3,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 1,
        orderId: 1,
      ),
      OrderItemModel(
        id: 4,
        quantity: 10,
        unitSalePrice: 10000,
        totalPrice: 100000,
        productId: 2,
        orderId: 1,
      ),
    ]);
    await addAllOrders([
      OrderModel(
        id: 0,
        status: OrderStatus.paid,
        date: DateTime.now(),
      ),
      OrderModel(
        id: 1,
        status: OrderStatus.paid,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }
}
