import 'package:postgres/postgres.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/data/database/database.dart';
import 'package:sales/data/models/category_model.dart';
import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/range_of_dates.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';

abstract interface class LocalPostgresStorage implements Database {}

/// Database using Postgres
class LocalPostgresStorageImpl implements LocalPostgresStorage {
  final ServerConfigurationsRepository _serverConfigurationRepository;
  late Connection _connection;

  /// Database using Postgres
  LocalPostgresStorageImpl(this._serverConfigurationRepository);

  @override
  Future<void> initial() async {
    final configurations = await _serverConfigurationRepository.loadConfigurations();
    _connection = await Connection.open(
      Endpoint(
        host: configurations.host,
        database: configurations.database,
        username: configurations.username,
        password: configurations.password,
      ),
      settings: configurations.host == 'localhost' || configurations.host == '127.0.0.1'
          ? const ConnectionSettings(sslMode: SslMode.disable)
          : null,
    );
  }

  @override
  Future<void> dispose() async {
    await _connection.close();
  }

  Future<void> clear() async {
    await _connection.runTx((session) async {
      await session.execute('DELETE FROM order_items');
      await session.execute('ALTER SEQUENCE order_items_sequence RESTART');
      await session.execute('UPDATE order_items SET oi_id = DEFAULT');
      await session.execute('DELETE FROM orders');
      await session.execute('ALTER SEQUENCE orders_sequence RESTART');
      await session.execute('UPDATE orders SET o_id = DEFAULT');
      await session.execute('DELETE FROM products');
      await session.execute('ALTER SEQUENCE products_sequence RESTART');
      await session.execute('UPDATE products SET p_id = DEFAULT');
      await session.execute('DELETE FROM categories');
      await session.execute('ALTER SEQUENCE categories_sequence RESTART');
      await session.execute('UPDATE categories SET c_id = DEFAULT');
    });
  }

  @override
  Future<void> addCategory(CategoryModel category, [Session? session]) async {
    const sql = 'INSERT INTO categories (c_name, c_description, c_deleted) VALUES (@name, @description, FALSE)';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'name': category.name,
        'description': category.description,
      },
    );
  }

  @override
  Future<void> updateCategory(CategoryModel category, [Session? session]) async {
    const sql =
        'UPDATE categories SET c_name = @name, c_description = @description, c_deleted = @deleted WHERE c_id=@id';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'id': category.id,
        'name': category.name,
        'description': category.description,
        'deleted': category.deleted,
      },
    );
  }

  @override
  Future<void> removeCategory(CategoryModel category) async {
    await updateCategory(category.copyWith(deleted: true));
  }

  @override
  Future<int> addOrder(OrderModel order, [Session? connection]) async {
    const sql = 'INSERT INTO orders (o_status, o_date, o_deleted) VALUES (@status, @date, FALSE) RETURNING o_id';
    final result = await (connection ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'status': order.status.name,
        'date': TypedValue(Type.timestampTz, order.date),
      },
    );

    return result.first.first as int;
  }

  @override
  Future<void> updateOrder(OrderModel order, [Session? session]) async {
    const sql = 'UPDATE orders SET o_status = @status, o_date = @date, o_deleted = @deleted WHERE o_id=@id';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'id': order.id,
        'status': order.status.name,
        'date': TypedValue(Type.timestampTz, order.date),
        'deleted': order.deleted,
      },
    );
  }

  @override
  Future<void> removeOrder(OrderModel order, [Session? session]) async {
    await updateOrder(order.copyWith(deleted: true), session);
  }

  @override
  Future<void> addOrderItem(OrderItemModel orderItem, [Session? connection]) async {
    const sql =
        'INSERT INTO order_items (oi_quantity, oi_unit_sale_price, oi_total_price, oi_product_id, oi_order_id, oi_deleted) VALUES (@quantity, @unitSalePrice, @totalPrice, @productId, @orderId, FALSE)';
    await (connection ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'quantity': orderItem.quantity,
        'unitSalePrice': orderItem.unitSalePrice,
        'totalPrice': orderItem.totalPrice,
        'productId': orderItem.productId,
        'orderId': orderItem.orderId,
      },
    );
  }

  @override
  Future<void> updateOrderItem(OrderItemModel orderItem, [Session? session]) async {
    const sql =
        'UPDATE order_items SET oi_quantity = @quantity, oi_unit_sale_price = @unitSalePrice, oi_total_price = @totalPrice, oi_product_id = @productId, oi_order_id = @orderId, oi_deleted = @deleted WHERE oi_id = @id';
    await (session ?? _connection).execute(Sql.named(sql), parameters: {
      'id': orderItem.id,
      'quantity': orderItem.quantity,
      'unitSalePrice': orderItem.unitSalePrice,
      'totalPrice': orderItem.totalPrice,
      'productId': orderItem.productId,
      'orderId': orderItem.orderId,
      'deleted': orderItem.deleted,
    });
  }

  @override
  Future<void> removeOrderItem(OrderItemModel orderItem, [Session? session]) async {
    await updateOrderItem(orderItem.copyWith(deleted: true), session);
  }

  @override
  Future<void> addProduct(ProductModel product, [Session? session]) async {
    const sql =
        'INSERT INTO products (p_sku, p_name, p_image_path, p_import_price, p_unit_sale_price, p_count, p_description, p_category_id, p_deleted) VALUES (@sku, @name, @imagePath, @importPrice, @unitSalePrice, @count, @description, @categoryId, @deleted)';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'sku': product.sku,
        'name': product.name,
        'imagePath': TypedValue(Type.varCharArray, product.imagePath),
        'importPrice': product.importPrice,
        'unitSalePrice': product.unitSalePrice,
        'count': product.count,
        'description': product.description,
        'categoryId': product.categoryId,
        'deleted': product.deleted,
      },
    );
  }

  @override
  Future<void> updateProduct(ProductModel product, [Session? session]) async {
    const sql = '''
    UPDATE 
        products 
    SET 
        p_sku = @sku, p_name = @name, p_image_path = @imagePath, p_import_price = @importPrice, p_unit_sale_price = @unitSalePrice, p_count = @count, p_description = @description, p_category_id = @categoryId, p_deleted = @deleted
    WHERE 
        p_id=@id
    ''';
    await (session ?? _connection).execute(Sql.named(sql), parameters: {
      'id': product.id,
      'sku': product.sku,
      'name': product.name,
      'imagePath': TypedValue(Type.varCharArray, product.imagePath),
      'importPrice': product.importPrice,
      'unitSalePrice': product.unitSalePrice,
      'count': product.count,
      'description': product.description,
      'categoryId': product.categoryId,
      'deleted': product.deleted,
    });
  }

  @override
  Future<void> removeProduct(ProductModel product, [Session? session]) async {
    await updateProduct(product.copyWith(deleted: true), session);
  }

  @override
  Future<ProductModel> getProductById(int id, [Session? session]) async {
    const sql = 'SELECT * FROM products WHERE p_id = @id';
    final result = await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {'id': id},
    );
    return ProductModel.fromMap(result.first.toColumnMap());
  }

  @override
  Future<List<CategoryModel>> getAllCategories([Session? session]) async {
    const sql = 'SELECT * FROM categories WHERE c_deleted=FALSE';
    final result = await (session ?? _connection).execute(sql);

    return result.map((e) => CategoryModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<OrderItemModel>> getAllOrderItems([GetOrderItemsParams? params, Session? session]) async {
    var sql = 'SELECT * FROM order_items WHERE oi_deleted=FALSE';
    if (params?.orderId != null) {
      sql += ' AND oi_order_id = ${params?.orderId}';
    }
    if (params?.productId != null) {
      sql += ' AND oi_product_id = ${params?.orderId}';
    }
    final result = await (session ?? _connection).execute(sql);

    return result.map((e) => OrderItemModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<OrderModel>> getAllOrders({RangeOfDates? dateRange, Session? session}) async {
    String sql = 'SELECT * FROM orders WHERE o_deleted=FALSE';
    final parameters = <String, Object>{};
    if (dateRange != null) {
      sql += " AND o_date::timestamptz >= @startDate::timestamptz";
      sql += " AND o_date::timestamptz <= @endDate::timestamptz";
      parameters.addAll({
        'startDate': dateRange.start.dateOnly(),
        'endDate': dateRange.end.dateOnly(),
      });
    }
    final result = await (session ?? _connection).execute(Sql.named(sql), parameters: parameters);

    return result.map((e) => OrderModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    String sql = 'SELECT * FROM products WHERE p_deleted = FALSE';
    final result = await _connection.execute(Sql.named(sql));

    return result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<void> addAllCategories(List<CategoryModel> categories) async {
    const sql = 'SELECT 1 FROM categories WHERE c_id = @id';
    await _connection.runTx((session) async {
      for (final category in categories) {
        final result = await session.execute(Sql.named(sql), parameters: {'id': category.id});
        if (result.isEmpty) {
          await addCategory(category, session);
        } else {
          await updateCategory(category, session);
        }
      }
    });
  }

  @override
  Future<void> addAllProducts(List<ProductModel> products) async {
    const sql = 'SELECT 1 FROM products WHERE p_id = @id';
    for (final product in products) {
      final result = await _connection.execute(Sql.named(sql), parameters: {'id': product.id});
      if (result.isEmpty) {
        await addProduct(product);
      } else {
        await updateProduct(product);
      }
    }
  }

  @override
  Future<int> getTotalProductCount() async {
    const sql = 'SELECT count(*) FROM products WHERE p_deleted = FALSE';
    final result = await _connection.execute(sql);

    return result.first.first as int? ?? 0;
  }

  @override
  Future<({int id, String sku})> getNextProductIdSku() async {
    const sql = 'SELECT last_value FROM products_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return (id: id, sku: 'P${id.toString().padLeft(8, '0')}');
  }

  @override
  Future<int> getNextCategoryId() async {
    const sql = 'SELECT last_value FROM categories_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return id;
  }

  @override
  Future<int> getNextOrderItemId() async {
    const sql = 'SELECT last_value FROM order_items_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return id;
  }

  @override
  Future<int> getNextOrderId() async {
    const sql = 'SELECT last_value FROM orders_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int? ?? 0;
    final id = count + 1;

    return id;
  }

  @override
  Future<void> addOrderWithOrderItems(OrderWithItemsParams<OrderModel, OrderItemModel> params) async {
    await _connection.runTx((session) async {
      final orderId = await addOrder(params.order, session);
      for (var orderItem in params.orderItems) {
        orderItem = orderItem.copyWith(orderId: orderId);
        await addOrderItem(orderItem, session);

        // Cập nhật lại số lượng của sản phẩm.
        var product = await getProductById(orderItem.productId, session);
        product = product.copyWith(count: product.count - orderItem.quantity);
        await updateProduct(product, session);
      }
    });
  }

  @override
  Future<int> getDailyOrderCount(DateTime date) async {
    final orders = await getOrders(GetOrderParams(dateRange: Ranges(date, date)));
    return orders.items.length;
  }

  @override
  Future<int> getDailyRevenue(DateTime date) async {
    final orders = await getOrders(GetOrderParams(dateRange: Ranges(date, date)));
    int total = 0;
    for (final order in orders.items) {
      final items = await getOrderItems(GetOrderItemsParams(orderId: order.id));
      for (final item in items) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  @override
  Future<Map<ProductModel, int>> getFiveHighestSalesProducts() async {
    const sql = '''
      SELECT
        *, SUM(oi_quantity) AS total_quantity
      FROM 
        products
      JOIN
        order_items ON p_id = oi_product_id
      WHERE
        p_deleted = FALSE AND oi_deleted = FALSE
      GROUP BY
        p_id, oi_id
      ORDER BY
        total_quantity DESC
      LIMIT 5
    ''';
    final result = await _connection.execute(sql);
    final columns = result.map((e) => e.toColumnMap());
    Map<ProductModel, int> maps = {};
    for (final column in columns) {
      maps.addAll({ProductModel.fromMap(column): column['total_quantity']});
    }

    return maps;
  }

  @override
  Future<List<ProductModel>> getFiveLowStockProducts() async {
    const sql = 'SELECT * FROM products WHERE p_deleted = FALSE AND p_count < 5 LIMIT 5';
    final result = await _connection.execute(sql);
    return result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<int>> getDailyRevenueForMonth(DateTime date) async {
    const sql = '''
      SELECT 
          TO_CHAR(o_date, 'DD') AS day,
          SUM(oi_total_price) AS total_revenue
      FROM 
          orders
      JOIN 
          order_items ON o_id = oi_order_id
      JOIN 
          products ON oi_product_id = p_id
      WHERE 
          o_deleted = FALSE AND oi_deleted = FALSE AND p_deleted = FALSE AND DATE_TRUNC('month', o_date::timestamptz) = DATE_TRUNC('month', @currentDate::timestamptz)
      GROUP BY 
          TO_CHAR(o_date, 'DD')
      ORDER BY 
          day ASC;
    ''';
    final result = await _connection.execute(Sql.named(sql), parameters: {'currentDate': date});
    final mapResult = <int, int>{};
    for (final e in result) {
      final map = e.toColumnMap();
      final day = int.parse(map['day']);
      final total = map['total_revenue'] as int;
      mapResult.putIfAbsent(day, () => 0);
      mapResult[day] = mapResult[day]! + total;
    }
    final listResult = <int>[];
    for (int i = 1; i <= date.day; i++) {
      listResult.add(mapResult[i] ?? 0);
    }
    return listResult;
  }

  @override
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params, Session? session]) async {
    String sql = 'SELECT * FROM order_items WHERE oi_deleted = FALSE';
    Map<String, dynamic> parameters = {};
    if (params != null) {
      if (params.orderId != null) {
        sql += ' AND oi_order_id = @orderId';
        parameters['orderId'] = TypedValue(Type.integer, params.orderId!);
      }

      if (params.productId != null) {
        sql += ' AND oi_product_id = @productId';
        parameters['productId'] = TypedValue(Type.integer, params.productId!);
      }
    }
    final result = await (session ?? _connection).execute(Sql.named(sql), parameters: parameters);
    return result.map((e) => OrderItemModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    String sql = 'SELECT * FROM orders WHERE o_deleted=FALSE';

    // Lọc theo ngày
    final start = params.dateRange?.start;
    final parameters = <String, Object>{};
    if (start != null) {
      sql += " AND o_date::timestamptz >= @startDate::timestamptz";
      parameters.addAll({
        'startDate': start,
      });
    }

    final end = params.dateRange?.end;
    if (end != null) {
      sql += " AND o_date::timestamptz <= @endDate::timestamptz";
      parameters.addAll({
        'endDate': end,
      });
    }

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    final orders = result.map((e) => OrderModel.fromMap(e.toColumnMap())).toList();

    return GetResult(
      totalCount: result.length,
      items: orders.skip((params.page - 1) * params.perpage).take(params.perpage).toList(),
    );
  }

  @override
  Future<GetResult<ProductModel>> getProducts([GetProductParams params = const GetProductParams()]) async {
    String sql = 'SELECT * FROM products WHERE p_deleted=FALSE';
    final Map<String, Object> parameters = {};

    if (params.isUseCategoryFilter) {
      sql += ' AND p_category_id = @categoryId';
      parameters.addAll({'categoryId': params.categoryIdFilter});
    }

    if (params.isUsePriceRangeFilter) {
      if (params.priceRange.start > 0 && params.priceRange.start != double.infinity) {
        sql += ' AND p_import_price >= @minValue';
        parameters.addAll({
          'minValue': params.priceRange.start.toInt(),
        });
      }

      if (params.priceRange.end > 0 && params.priceRange.end != double.infinity) {
        sql += ' AND p_import_price <= @maxValue';
        parameters.addAll({
          'maxValue': params.priceRange.end.toInt(),
        });
      }
    }

    // TODO: Tìm cách normalize trước khi query để hiển thị kết quả tốt hơn
    if (params.searchText.isNotEmpty) {
      sql += ' AND LOWER(p_name) LIKE LOWER(@searchText)';
      parameters.addAll({'searchText': '%${params.searchText}%'});
    }

    sql += ' ORDER BY ${params.orderBy.sql}';

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    final products = result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();

    return GetResult(
      totalCount: result.length,
      items: products.skip((params.page - 1) * params.perPage).take(params.perPage).toList(),
    );
  }

  @override
  Future<RecentOrdersResultModel> getThreeRecentOrders() async {
    const sql = '''
      SELECT 
        *
      FROM 
        orders
      JOIN
        order_items ON oi_order_id = o_id
      JOIN
        products ON oi_product_id = p_id
      WHERE 
        o_deleted = FALSE AND oi_deleted = FALSE AND p_deleted = FALSE
      ORDER BY
        o_date DESC
      LIMIT
        3
    ''';
    final result = await _connection.execute(sql);
    final Map<OrderModel, List<ProductModel>> products = {};
    final Map<OrderModel, List<OrderItemModel>> orderItems = {};
    for (final row in result) {
      final rowMap = row.toColumnMap();
      final order = OrderModel.fromMap(rowMap);
      final product = ProductModel.fromMap(rowMap);
      final orderItem = OrderItemModel.fromMap(rowMap);

      products.putIfAbsent(order, () => []);
      products[order]!.add(product);

      orderItems.putIfAbsent(order, () => []);
      orderItems[order]!.add(orderItem);
    }
    return RecentOrdersResultModel(orderItems: orderItems, products: products);
  }

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

  @override
  Future<void> replace(List<CategoryModel> categories, List<ProductModel> products) async {
    await clear();
    await addAllCategories(categories);
    await addAllProducts(products);
  }

  @override
  Future<void> removeOrderWithItems(OrderModel order) async {
    await _connection.runTx((session) async {
      final orderItems = await getAllOrderItems(GetOrderItemsParams(orderId: order.id), session);
      for (final orderItem in orderItems) {
        final tempOrderItems = orderItem.copyWith(deleted: true);
        await updateOrderItem(tempOrderItems, session);

        // Cập nhật lại số lượng sản phẩm.
        var product = await getProductById(orderItem.productId, session);
        product = product.copyWith(count: product.count + orderItem.quantity);
        await updateProduct(product, session);
      }
      await removeOrder(order, session);
    });
  }

  @override
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems) async {
    await _connection.runTx((session) async {
      for (final item in orderItems) {
        await addOrderItem(item, session);
      }
    });
  }

  @override
  Future<void> addAllOrders(List<OrderModel> orders) async {
    await _connection.runTx((session) async {
      for (final item in orders) {
        await addOrder(item, session);
      }
    });
  }

  @override
  Future<void> updateOrderWithItems(OrderWithItemsParams<OrderModel, OrderItemModel> params) async {
    await _connection.runTx((session) async {
      await updateOrder(params.order, session);
      final orderItemsFromDatabase = await getOrderItems(GetOrderItemsParams(orderId: params.order.id), session);

      // Thêm và chỉnh sửa chi tiết đơn hàng
      for (final orderItem in params.orderItems) {
        final index = orderItemsFromDatabase.indexWhere((e) => e.id == orderItem.id);
        if (index == -1) {
          await addOrderItem(orderItem, session);

          // Cập nhật lại số lượng sản phẩm.
          var product = await getProductById(orderItem.productId, session);
          product = product.copyWith(count: product.count - orderItem.quantity);
          await updateProduct(product, session);
        } else {
          await updateOrderItem(orderItem, session);

          // Cập nhật lại số lượng sản phẩm.
          final databaseCount = orderItemsFromDatabase[index].quantity;
          final newCount = orderItem.quantity;
          final differentCount = databaseCount - newCount;
          var product = await getProductById(orderItem.productId, session);
          product = product.copyWith(count: product.count + differentCount);
          await updateProduct(product, session);
        }
      }

      // Xoá chi tiết đơn hàng
      for (final orderItem in orderItemsFromDatabase) {
        final index = params.orderItems.indexWhere((e) => e.id == orderItem.id);
        if (index == -1) {
          await removeOrderItem(orderItem, session);

          // Cập nhật lại số lượng sản phẩm.
          var product = await getProductById(orderItem.productId, session);
          product = product.copyWith(count: product.count + orderItem.quantity);
          await updateProduct(product, session);
        }
      }
    });
  }

  @override
  Future<void> backup(String backupPath) {
    // TODO: implement backup
    throw UnimplementedError();
  }

  @override
  Future<void> restore(String backupPath) {
    // TODO: implement restore
    throw UnimplementedError();
  }

  @override
  Future<Map<ProductModel, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange) async {
    String sql = '''
      SELECT
          *, SUM(oi_quantity) AS total_quantity
      FROM
          order_items
      JOIN 
          products ON oi_product_id = p_id
      JOIN
          orders ON oi_order_id = o_id
      WHERE
          p_deleted = FALSE AND o_deleted = FALSE AND o_date::timestamptz >= @startDate::timestamptz AND o_date::timestamptz <= @endDate::timestamptz
      GROUP BY
          p_id, oi_id, o_id
      ORDER BY
          o_date
    ''';
    final parameters = {
      'startDate': dateRange.start.dateOnly(),
      'endDate': dateRange.end.dateOnly(),
    };

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    final mapResult = <ProductModel, int>{};
    for (final e in result) {
      final map = e.toColumnMap();
      final productModel = ProductModel.fromMap(map);
      final quantity = map['total_quantity'] as int;

      mapResult.putIfAbsent(productModel, () => 0);
      mapResult[productModel] = mapResult[productModel]! + quantity;
    }

    return mapResult;
  }

  @override
  Future<int> getRevenue(Ranges<DateTime> dateRange) async {
    String sql = '''
      SELECT
          SUM(oi_total_price) AS total_price
      FROM
          orders
      JOIN
          order_items ON o_id = oi_order_id
      WHERE
          o_deleted = FALSE AND oi_deleted = FALSE AND o_date::timestamptz >= @startDate::timestamptz AND o_date::timestamptz <= @endDate::timestamptz
    ''';
    final parameters = {
      'startDate': dateRange.start.dateOnly(),
      'endDate': dateRange.end.dateOnly(),
    };

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    return (result.first.first as int?) ?? 0;
  }

  @override
  Future<int> getProfit(Ranges<DateTime> dateRange) async {
    String sql = '''
      SELECT
          SUM((oi_unit_sale_price - p_import_price) * oi_quantity) AS profit
      FROM
          order_items
      JOIN
          products ON oi_product_id = p_id
      JOIN
          orders ON oi_order_id = o_id
      WHERE
          oi_deleted = FALSE AND p_deleted = FALSE AND o_deleted= FALSE AND o_date::timestamptz >= @startDate::timestamptz AND o_date::timestamptz <= @endDate::timestamptz
    ''';
    final parameters = {
      'startDate': dateRange.start.dateOnly(),
      'endDate': dateRange.end.dateOnly(),
    };

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    return (result.first.first as int?) ?? 0;
  }
}
