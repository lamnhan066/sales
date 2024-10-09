import 'package:postgres/postgres.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/core/utils/utils.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/order_with_items_params.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/range_of_dates.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/infrastucture/database/base_database.dart';
import 'package:sales/infrastucture/database/models/category_model.dart';
import 'package:sales/infrastucture/database/models/get_orders_result_model.dart';
import 'package:sales/infrastucture/database/models/order_item_model.dart';
import 'package:sales/infrastucture/database/models/order_model.dart';
import 'package:sales/infrastucture/database/models/product_model.dart';

/// Database using Postgres
class PostgresDatabase implements BaseDatabase {
  late Connection _connection;

  /// Database using Postgres
  PostgresDatabase();

  @override
  Future<void> initial() async {
    final postgresSettings = getIt<AppController>().postgresConfigurations;
    _connection = await Connection.open(
      Endpoint(
        host: postgresSettings.host,
        database: postgresSettings.database,
        username: postgresSettings.username,
        password: postgresSettings.password,
      ),
      settings: postgresSettings.host == 'localhost' || postgresSettings.host == '127.0.0.1'
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
    const sql = 'INSERT INTO categories (c_name, c_description) VALUES (@name, @description)';
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
        'UPDATE categories SET c_id = @id, c_name = @name, c_description = @description, c_deleted = @deleted WHERE c_id=@id';
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
  Future<void> addOrder(OrderModel order, [Session? connection]) async {
    const sql = 'INSERT INTO orders (c_status, c_date) VALUES (@status, @date)';
    await (connection ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'status': order.status.name,
        'date': TypedValue(Type.date, order.date),
      },
    );
  }

  @override
  Future<void> updateOrder(OrderModel order, [Session? session]) async {
    const sql =
        'UPDATE orders SET o_id = @id,  o_status = @status, o_date = @date, o_deleted = @deleted WHERE o_id=@id';
    await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'id': order.id,
        'status': order.status.name,
        'date': order.date,
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
        'INSERT INTO orders (oi_quantity, oi_unit_sale_price, oi_total_price, oi_product_id, oi_order_id) VALUES (@quantity, @unitSalePrice, @totalPrice, @productId, @orderId)';
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
  Future<void> updateOrderItem(OrderItemModel orderItem) async {
    const sql =
        'UPDATE orders SET oi_id = @id,  oi_quantity = @quantity, oi_unit_sale_price = @unitSalePrice, oi_total_price = @totalPrice, oi_product_id = @productId, oi_order_id = @orderId WHERE oi_id = @id';
    await _connection.execute(Sql.named(sql), parameters: orderItem.toMap());
  }

  @override
  Future<void> removeOrderItem(OrderItemModel orderItem) async {
    await updateOrderItem(orderItem.copyWith(deleted: true));
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    const sql =
        'INSERT INTO products (p_sku, p_name, p_image_path, p_import_price, p_count, p_description, p_category_id) VALUES (@sku, @name, @imagePath, @importPrice, @count, @description, @categoryId)';
    await _connection.execute(
      Sql.named(sql),
      parameters: {
        'sku': product.sku,
        'name': product.name,
        'imagePath': TypedValue(Type.varCharArray, product.imagePath),
        'importPrice': product.importPrice,
        'count': product.count,
        'description': product.description,
        'categoryId': product.categoryId,
      },
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    const sql =
        'UPDATE products SET p_id = @id,  p_sku = @sku, p_name = @name, p_image_path = @imagePath, p_import_price = @importPrice, p_count = @count, p_description = @description, p_category_id = @categoryId, p_deleted = @deleted WHERE p_id=@id';
    await _connection.execute(Sql.named(sql), parameters: product.toMap());
  }

  @override
  Future<void> removeProduct(ProductModel product) async {
    await updateProduct(product.copyWith(deleted: true));
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    const sql = 'SELECT DISTINCT ON (p_id) FROM products WHERE p_id = @id';
    final result = await _connection.execute(
      Sql.named(sql),
      parameters: {
        'id': id,
      },
    );
    return ProductModel.fromMap(result.first.toColumnMap());
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    const sql = 'SELECT * FROM categories WHERE c_deleted=FALSE';
    final result = await _connection.execute(sql);

    return result.map((e) => CategoryModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<OrderItemModel>> getAllOrderItems({
    int? orderId,
    int? productId,
  }) async {
    var sql = 'SELECT * FROM order_items WHERE oi_deleted=FALSE';
    if (orderId != null) {
      sql += ' AND oi_order_id = $orderId';
    }
    if (productId != null) {
      sql += ' AND oi_product_id = $orderId';
    }
    final result = await _connection.execute(sql);

    return result.map((e) => OrderItemModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<OrderModel>> getAllOrders({RangeOfDates? dateRange}) async {
    String sql = 'SELECT * FROM orders WHERE o_deleted=FALSE';
    if (dateRange != null) {
      sql += " AND o_date >= '${Utils.dateToSql(dateRange.start)}'";
      sql += " AND o_date <= '${Utils.dateToSql(dateRange.end)}'";
    }
    final result = await _connection.execute(sql);

    return result.map((e) => OrderModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    Ranges<double>? rangeValues,
    int? categoryId,
  }) async {
    String sql = 'SELECT * FROM products WHERE p_deleted=FALSE';
    final result = await _connection.execute(Sql.named(sql));

    return result.map((e) => ProductModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<void> addAllCategories(List<CategoryModel> categories) async {
    const sql = 'SELECT * FROM categories WHERE c_id = @id';
    await _connection.runTx((session) async {
      for (final category in categories) {
        final result = await _connection.execute(Sql.named(sql), parameters: {'id': category.id});
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
    const sql = 'SELECT * FROM products WHERE p_id = @id';
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
      await addOrder(params.order, session);
      for (final item in params.orderItems) {
        await addOrderItem(item, session);
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
        p_id, p_sku, p_name, p_image_path, p_import_price, p_count, p_description, p_category_id, p_deleted, SUM(oi_quantity) AS total_quantity
      FROM 
        products
      LEFT JOIN
        order_items ON p_id = oi_product_id
      WHERE
        p_deleted = FALSE
      GROUP BY
        p_id
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
    const sql = 'SELECT * FROM products WHERE p_deleted = FALSE AND p_quantity < 5 LIMIT 5';
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
          order_items ON o_id = oi_id
      JOIN 
          products ON oi_product_id = p_id
      WHERE 
          DATE_TRUNC('month', o_date) = DATE_TRUNC('month', @currentDate)
      GROUP BY 
          TO_CHAR(o_date, 'DD')
      ORDER BY 
          day ASC;
    ''';
    final result = await _connection.execute(Sql.named(sql), parameters: {'currentDate': date});
    return result.map((e) => e.toColumnMap()['total_revenue']).toList().cast<int>();
  }

  @override
  Future<List<OrderItemModel>> getOrderItems([GetOrderItemsParams? params]) async {
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
    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    return result.map((e) => OrderItemModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    String sql = 'SELECT * FROM orders WHERE o_deleted=FALSE';
    if (params.dateRange != null) {
      sql += " AND o_date >= '${Utils.dateToSql(params.dateRange!.start)}'";
      sql += " AND o_date <= '${Utils.dateToSql(params.dateRange!.end)}'";
    }
    final result = await _connection.execute(sql);
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

    if (params.categoryIdFilter != null) {
      sql += ' AND p_category_id = @categoryId';
      parameters.addAll({'categoryId': params.categoryIdFilter!});
    }

    if (params.priceRange != null) {
      if (params.priceRange!.start > 0 && params.priceRange!.start != double.infinity) {
        sql += ' AND p_import_price >= @minValue';
        parameters.addAll({
          'minValue': params.priceRange!.start.toInt(),
        });
      }

      if (params.priceRange!.end > 0 && params.priceRange!.end != double.infinity) {
        sql += ' AND p_import_price <= @maxValue';
        parameters.addAll({
          'maxValue': params.priceRange!.end.toInt(),
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
        o_deleted = FALSE
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
    const orderItemsSql = 'UPDATE order_items SET oi_deleted = TRUE WHERE oi_order_id = @orderId';
    final params = {'orderId': order.id};
    await _connection.runTx((session) async {
      await session.execute(Sql.named(orderItemsSql), parameters: params);
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
    });
  }
}
