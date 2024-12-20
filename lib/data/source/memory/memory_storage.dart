import 'dart:math';

import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/order_with_items_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/data/repositories/category_database_repository.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/data_sync_database_repository.dart';
import 'package:sales/data/repositories/order_database_repository.dart';
import 'package:sales/data/repositories/order_item_database_repository.dart';
import 'package:sales/data/repositories/order_with_items_database_repository.dart';
import 'package:sales/data/repositories/product_database_repository.dart';
import 'package:sales/data/repositories/report_database_repository.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:string_normalizer/string_normalizer.dart';

abstract class MemoryStorage
    implements
        CoreDatabaseRepository,
        DataSyncDatabaseRepository,
        ProductDatabaseRepository,
        CategoryDatabaseRepository,
        OrderDatabaseRepository,
        OrderItemDatabaseRepository,
        OrderWithItemsDatabaseRepository,
        ReportDatabaseRepository {}

class MemoryStorageImpl implements MemoryStorage {
  final _categories = <CategoryModel>[];
  final _products = <ProductModel>[];
  final _orderItems = <OrderItemModel>[];
  final _orders = <OrderModel>[];

  @override
  Future<void> initial() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> clear() async {
    _categories.clear();
    _products.clear();
    _orderItems.clear();
    _orders.clear();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    _categories.add(category);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final i = _categories.indexWhere((item) => item.id == category.id);
    _categories[i] = category;
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async => _categories;

  @override
  Future<void> addAllCategories(List<CategoryModel> categories) async {
    _categories
      ..clear()
      ..addAll(categories);
  }

  @override
  Future<({int id, String sku})> getNextProductIdSku() async {
    final count = await getTotalProductCount();
    final id = count + 1;

    return (id: id, sku: 'P${(id - 1).toString().padLeft(8, '0')}');
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final i = _products.indexWhere((item) => item.id == product.id);
    _products[i] = product;
  }

  @override
  Future<void> addAllProducts(List<ProductModel> products) async {
    _products
      ..clear()
      ..addAll(products);
  }

  @override
  Future<GetResult<ProductModel>> getProducts([GetProductParams params = const GetProductParams()]) async {
    final result = _products.where((product) {
      // Sản phẩm đã bị xoá.
      if (product.deleted) return false;

      // Lọc theo loại hàng.
      if (params.isUseCategoryFilter && product.categoryId != params.categoryIdFilter) {
        return false;
      }

      // Lọc theo mức giá.
      var priceFilter = true;
      if (params.isUsePriceRangeFilter) {
        priceFilter = product.importPrice >= params.priceRange.start && product.importPrice <= params.priceRange.end;
      }

      // Tìm kiếm.
      var search = true;
      if (params.searchText.isNotEmpty) {
        search = product.name.normalize().toLowerCase().contains(params.searchText);
      }

      return priceFilter && search;
    }).toList();

    switch (params.orderBy) {
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

    return GetResult(
      totalCount: result.length,
      items: result.skip((params.page - 1) * params.perPage).take(params.perPage).toList(),
    );
  }

  @override
  Future<List<ProductModel>> getAllProducts([GetProductParams params = const GetProductParams()]) async {
    return _products;
  }

  @override
  Future<int> addOrder(OrderModel order) async {
    _orders.add(order);
    return order.id;
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    final i = _orders.indexWhere((item) => item.id == order.id);
    _orders[i] = order;
  }

  @override
  Future<void> removeOrder(OrderModel order) async {
    final tempOrder = order.copyWith(deleted: true);
    await updateOrder(tempOrder);
  }

  @override
  Future<List<OrderModel>> getAllOrders({Ranges<DateTime?>? dateRange}) async {
    final orders = _orders.where((o) {
      if (o.deleted) return false;

      // Lọc theo ngày
      final start = dateRange?.start;
      if (start != null && o.date.isBefore(start)) return false;

      final end = dateRange?.end;
      if (end != null && o.date.isAfter(end)) return false;

      return true;
    });

    return orders.toList();
  }

  @override
  Future<void> addAllOrders(List<OrderModel> orders) async {
    _orders
      ..clear()
      ..addAll(orders);
  }

  @override
  Future<void> addOrderItem(OrderItemModel orderItem) async {
    _orderItems.add(orderItem);
  }

  @override
  Future<void> updateOrderItem(OrderItemModel orderItem) async {
    final i = _orderItems.indexWhere((item) => item.id == orderItem.id);
    _orderItems[i] = orderItem;
  }

  @override
  Future<void> removeOrderItem(OrderItemModel orderItem) async {
    final tempOrderItem = orderItem.copyWith(deleted: true);
    await updateOrderItem(tempOrderItem);
  }

  @override
  Future<List<OrderItemModel>> getAllOrderItems([GetOrderItemsParams? params]) async {
    return _orderItems.where((e) {
      if (e.deleted) return false;
      if (params?.orderId != null && e.orderId != params?.orderId) return false;
      if (params?.productId != null && e.productId != params?.productId) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems) async {
    _orderItems
      ..clear()
      ..addAll(orderItems);
  }

  @override
  Future<int> addOrderWithItems(OrderWithItemsParamsModel params) async {
    final orderId = await addOrder(params.order);
    for (final orderItem in params.orderItems) {
      await addOrderItem(orderItem);

      // Cập nhật lại số lượng của sản phẩm.
      var product = await getProductById(orderItem.productId);
      product = product.copyWith(count: product.count - orderItem.quantity);
      await updateProduct(product);
    }
    return orderId;
  }

  @override
  Future<int> getNextCategoryId() async {
    final categories = await getAllCategories();
    final count = categories.length;
    final id = count + 1;

    return id;
  }

  @override
  Future<int> getNextOrderId() async {
    final orders = await getAllOrders();
    final count = orders.length;
    final id = count + 1;

    return id;
  }

  @override
  Future<int> getNextOrderItemId() async {
    final orderItems = await getAllOrderItems();
    final count = orderItems.length;
    final id = count + 1;

    return id;
  }

  @override
  Future<int> getDailyOrderCount(DateTime dateTime) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) => o.date.year == dateTime.year && o.date.month == dateTime.month && o.date.day == dateTime.day,
    );

    return dailyOrders.length;
  }

  @override
  Future<int> getDailyRevenue(DateTime dateTime) async {
    final orders = await getAllOrders();
    final dailyOrders = orders.where(
      (o) => o.date.year == dateTime.year && o.date.month == dateTime.month && o.date.day == dateTime.day,
    );
    final orderItems = await getAllOrderItems();
    var revenue = 0;
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
    final entries = orderedProductQuantities.entries
      ..toList().sort(
        (MapEntry<ProductModel, int> a, MapEntry<ProductModel, int> b) => a.value.compareTo(b.value),
      );

    return Map<ProductModel, int>.fromEntries(entries);
  }

  @override
  Future<List<ProductModel>> getFiveLowStockProducts() async {
    final products = await getAllProducts();
    final lowStockProducts = products.where((p) => p.count < 5).toList();

    return lowStockProducts.sublist(0, min(lowStockProducts.length, 5)).toList();
  }

  @override
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime) async {
    final orders = await getAllOrders();
    final monthlyOrders = orders.where(
      (o) => o.date.year == dateTime.year && o.date.month == dateTime.month,
    );
    final orderItems = await getAllOrderItems();
    final revenues = <int>[];

    final now = DateTime.now();
    for (var i = 1; i <= 31; i++) {
      if (DateTime(dateTime.year, dateTime.month, i).isAfter(now)) {
        break;
      }

      var revenue = 0;
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
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params = const GetOrderItemsParams()]) {
    return getAllOrderItems(GetOrderItemsParams(orderId: params?.orderId, productId: params?.productId));
  }

  @override
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    final result = await getAllOrders(dateRange: params.dateRange);

    return GetResult(
      totalCount: result.length,
      items: result.skip((params.page - 1) * params.perpage).take(params.perpage).toList(),
    );
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final products = await getAllProducts();
    return products.firstWhere((e) => e.id == id);
  }

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

    return RecentOrdersResultModel(orderItems: orderItemMap, products: productMap);
  }

  @override
  Future<int> getTotalProductCount() async {
    final products = await getAllProducts();

    return products.length;
  }

  @override
  Future<void> merge(List<CategoryModel> categories, List<ProductModel> products) async {
    final tempCategories = await getAllCategories();
    final cIndex = tempCategories.length;
    for (var i = 0; i < categories.length; i++) {
      final c = categories.elementAt(i).copyWith(id: cIndex + i);
      tempCategories.add(c);
    }
    await addAllCategories(tempCategories);

    final tempProducts = await getAllProducts();
    final pIndex = tempProducts.length;
    for (var i = 0; i < products.length; i++) {
      final newIndex = pIndex + i;
      final p = products.elementAt(i).copyWith(
            id: newIndex,
            sku: 'P${newIndex.toString().padLeft(8, '0')}',
          );
      tempProducts.add(p);
    }
    await addAllProducts(tempProducts);
  }

  @override
  Future<void> removeCategory(CategoryModel category) async {
    final tempCategory = category.copyWith(deleted: true);
    await updateCategory(tempCategory);
  }

  @override
  Future<void> removeOrderWithItems(OrderModel order) async {
    final orderItems = await getAllOrderItems(GetOrderItemsParams(orderId: order.id));
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

  @override
  Future<void> removeProduct(ProductModel product) async {
    final tempProduct = product.copyWith(deleted: true);
    await updateProduct(tempProduct);
  }

  @override
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products) async {
    await addAllCategories(categories);
    await addAllProducts(products);
  }

  @override
  Future<void> updateOrderWithItems(OrderWithItemsParamsModel params) async {
    await updateOrder(params.order);
    final orderItemsFromDatabase = await getOrderItems(GetOrderItemsParams(orderId: params.order.id));

    // Thêm và chỉnh sửa chi tiết đơn hàng
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

    // Xoá chi tiết đơn hàng
    for (final orderItem in orderItemsFromDatabase) {
      final index = params.orderItems.indexWhere((e) => e.id == orderItem.id);
      if (index == -1) {
        await removeOrderItem(orderItem);

        // Cập nhật lại số lượng sản phẩm.
        var product = await getProductById(orderItem.productId);
        product = product.copyWith(count: product.count + orderItem.quantity);
        await updateProduct(product);
      }
    }
  }

  @override
  Future<Map<ProductModel, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange) async {
    final products = await getProducts();
    final items = await getAllOrderItems();
    return {for (final e in products.items) e: items.where((i) => i.productId == e.id).length};
  }

  @override
  Future<int> getRevenue(Ranges<DateTime> dateRange) async {
    final items = await getAllOrderItems();
    final orders = (await getOrders()).items.where((e) {
      if (e.date.isAfter(dateRange.start) && e.date.isBefore(dateRange.end)) {
        return true;
      }
      return false;
    });
    var result = 0;
    for (final order in orders) {
      final tempItems = items.where((e) => e.orderId == order.id);
      for (final item in tempItems) {
        result += item.totalPrice;
      }
    }
    return result;
  }

  @override
  Future<int> getProfit(Ranges<DateTime> dateRange) async {
    final items = await getOrderItems();
    final products = await getProducts();
    final orders = (await getOrders()).items.where((e) {
      if (e.date.isAfter(dateRange.start) && e.date.isBefore(dateRange.end)) {
        return true;
      }
      return false;
    });
    var result = 0;
    for (final order in orders) {
      final tempItems = items.where((e) => e.orderId == order.id);

      for (final item in tempItems) {
        final tempProduct = products.items.firstWhere((e) => e.id == item.productId);
        result += item.totalPrice - tempProduct.unitSalePrice * item.quantity;
      }
    }
    return result;
  }

  @override
  Future<void> addAllOrdersWithItems(List<OrderWithItemsParamsModel> orderWithItems) async {
    for (final item in orderWithItems) {
      await addOrderWithItems(item);
    }
  }

  @override
  Future<List<OrderWithItemsParamsModel>> getAllOrdersWithItems() async {
    final orders = await getOrders();
    final result = <OrderWithItemsParamsModel>[];
    for (final order in orders.items) {
      final orderItems = await getOrderItems(GetOrderItemsParams(orderId: order.id));
      result.add(OrderWithItemsParamsModel(order: order, orderItems: orderItems));
    }
    return result;
  }
}
