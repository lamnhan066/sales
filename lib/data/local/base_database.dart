import 'dart:math';

import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';

import '../repositories/database.dart';

/// Database abstract.
abstract class BaseDatabase implements Database {
  /// Nhập dữ liệu với vào dữ liệu hiện tại.
  ///
  /// Việc nhập này sẽ tiến hành tạo `id` và `sku` mới, do đó dữ liệu đã nhập
  /// vào sẽ có các trường này khác với thông tin ở [categories] và [products].
  @override
  Future<void> merge(List<CategoryModel> categories, List<ProductModel> products) async {
    final tempCategories = await getAllCategories();
    final cIndex = tempCategories.length;
    for (int i = 0; i < categories.length; i++) {
      final c = categories.elementAt(i).copyWith(id: cIndex + i);
      tempCategories.add(c);
    }
    await addAllCategories(tempCategories);

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
    await addAllProducts(tempProducts);
  }

  /// Thay thế dữ liệu đang có với dữ liệu mới.
  ///
  /// Việc thay thế này sẽ dẫn đến dữ liệu ở database bị xoá hoàn toàn
  /// và được thay thế mới.
  @override
  Future<void> replace(
    List<CategoryModel> categories,
    List<ProductModel> products,
  ) async {
    await addAllCategories(categories);
    await addAllProducts(products);
  }

  /// Xoá loại hàng.
  @override
  Future<void> removeCategory(CategoryModel category) async {
    final tempCategory = category.copyWith(deleted: true);
    await updateCategory(tempCategory);
  }

  /// Trình tạo ra `id` và `sku` cho sản phẩm.
  @override
  Future<({int id, String sku})> getNextProductIdSku() async {
    final count = await getTotalProductCount();
    final id = count + 1;

    return (id: id, sku: 'P${id.toString().padLeft(8, '0')}');
  }

  /// Trình tạo ra `id` cho loại hàng.
  @override
  Future<int> getNextCategoryId() async {
    final categories = await getAllCategories();
    final count = categories.length;
    final id = count + 1;

    return id;
  }

  /// Xoá sản phẩm.
  @override
  Future<void> removeProduct(ProductModel product) async {
    final tempProduct = product.copyWith(deleted: true);
    await updateProduct(tempProduct);
  }

  /// Lấy sản phẩm thông qua ID.
  @override
  Future<ProductModel> getProductById(int id) async {
    final products = await getAllProducts();
    return products.firstWhere((e) => e.id == id);
  }

  /// Trình tạo ra `id` cho loại hàng.
  @override
  Future<int> getNextOrderId() async {
    final orders = await getAllOrders();
    final count = orders.length;
    final id = count + 1;

    return id;
  }

  /// Xoá đơn đặt hàng.
  @override
  Future<void> removeOrder(OrderModel order) async {
    final tempOrder = order.copyWith(deleted: true);
    await updateOrder(tempOrder);
  }

  /// Trình tạo ra `id` cho chi tiết đơn hàng.
  @override
  Future<int> getNextOrderItemId() async {
    final orderItems = await getAllOrderItems();
    final count = orderItems.length;
    final id = count + 1;

    return id;
  }

  /// Xoá chi tiết sản phẩm đã đặt hàng.
  @override
  Future<void> removeOrderItem(OrderItemModel orderItem) async {
    final tempOrderItem = orderItem.copyWith(deleted: true);
    await updateOrderItem(tempOrderItem);
  }

  /// Lấy danh sách chi tiết sản phẩm đã đặt theo mã đơn và mã sản phẩm.
  @override
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params]) => getAllOrderItems();

  /// Lấy tổng số lượng sản phẩm có trong CSDL.
  @override
  Future<int> getTotalProductCount() async {
    final products = await getAllProducts();

    return products.length;
  }

  /// Thêm OrderModel cùng với OrderItems
  @override
  Future<void> addOrderWithOrderItems(OrderWithItemsParams<OrderModel, OrderItemModel> params) async {
    await addOrder(params.order);
    for (final orderItem in params.orderItems) {
      await addOrderItem(orderItem);

      // Cập nhật lại số lượng của sản phẩm.
      var product = await getProductById(orderItem.productId);
      product = product.copyWith(count: product.count - orderItem.quantity);
      await updateProduct(product);
    }
  }

  /// Cập nhật OrderModel cùng với OrderItems
  @override
  Future<void> updateOrderWithItems(OrderWithItemsParams<OrderModel, OrderItemModel> params) async {
    await updateOrder(params.order);
    final orderItemsFromDatabase = await getOrderItems(GetOrderItemsParams(orderId: params.order.id));
    for (final orderItem in params.orderItems) {
      final index = orderItemsFromDatabase.indexWhere((e) => e.id == orderItem.id);
      if (index == -1) {
        await addOrderItem(orderItem);

        // Cập nhật lại số lượng sản phẩm.
        var product = await getProductById(orderItem.productId);
        product = product.copyWith(count: product.count - orderItem.quantity);
        await updateProduct(product);
      } else {
        await updateOrderItem(orderItem);

        // Cập nhật lại số lượng sản phẩm.
        final databaseCount = orderItemsFromDatabase[index].quantity;
        final newCount = orderItem.quantity;
        final differentCount = databaseCount - newCount;
        var product = await getProductById(orderItem.productId);
        product = product.copyWith(count: product.count + differentCount);
        await updateProduct(product);
      }
    }
  }

  /// Xoá OrderModel cùng với OrderItems
  @override
  Future<void> removeOrderWithItems(OrderModel order) async {
    final orderItems = await getOrderItems(GetOrderItemsParams(orderId: order.id));
    for (final orderItem in orderItems) {
      final tempOrderItems = orderItem.copyWith(deleted: true);
      await updateOrderItem(tempOrderItems);

      // Cập nhật lại số lượng sản phẩm.
      var product = await getProductById(orderItem.productId);
      product = product.copyWith(count: product.count + orderItem.quantity);
      await updateProduct(product);
    }
    await removeOrder(order);
  }

  /// Lấy danh sách 5 sản phẩm có số lượng ít hơn 5 trong kho.
  @override
  Future<List<ProductModel>> getFiveLowStockProducts() async {
    final products = await getAllProducts();
    final lowStockProducts = products.where((p) => p.count < 5).toList();

    return lowStockProducts.sublist(0, min(lowStockProducts.length, 5));
  }

  /// Lấy danh sách 5 sản phẩm bán chạy nhất.
  @override
  Future<Map<ProductModel, int>> getFiveHighestSalesProducts() async {
    final products = await getAllProducts();
    final orderItems = await getAllOrderItems();
    final orderedProductQuantities = <ProductModel, int>{};
    for (final p in products) {
      for (final orderItem in orderItems) {
        if (orderItem.productId == p.id) {
          orderedProductQuantities.putIfAbsent(p, () => 0);
          orderedProductQuantities[p] = orderedProductQuantities[p]! + orderItem.quantity;
        }
      }
    }
    final entries = orderedProductQuantities.entries.toList();
    entries.sort(
      (MapEntry<ProductModel, int> a, MapEntry<ProductModel, int> b) => a.value.compareTo(b.value),
    );

    return Map<ProductModel, int>.fromEntries(entries);
  }

  /// Lấy số lượng đơn đặt hàng hằng ngày.
  @override
  Future<int> getDailyOrderCount(DateTime date) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) => o.date.year == date.year && o.date.month == date.month && o.date.day == date.day,
    );

    return dailyOrders.length;
  }

  /// Lấy tổng doanh thu hằng ngày.
  @override
  Future<int> getDailyRevenue(DateTime date) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) => o.date.year == date.year && o.date.month == date.month && o.date.day == date.day,
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
  @override
  Future<List<int>> getDailyRevenueForMonth(DateTime date) async {
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
  @override
  Future<RecentOrdersResultModel> getThreeRecentOrders() async {
    final orders = await getAllOrders();
    orders.sort((a, b) => a.date.compareTo(b.date));
    final orderItemMap = <OrderModel, List<OrderItemModel>>{};
    final orderItems = await getAllOrderItems();
    for (final order in orders.sublist(0, min(orders.length, 3))) {
      orderItemMap.putIfAbsent(order, () => []);
      for (final item in orderItems) {
        if (item.orderId == order.id) {
          orderItemMap[order]!.add(item);
        }
      }
    }

    final productMap = <OrderModel, List<ProductModel>>{};
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

    return RecentOrdersResultModel(
      orderItems: orderItemMap,
      products: productMap,
    );
  }
}
