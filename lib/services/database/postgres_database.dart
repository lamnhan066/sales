import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:sales/app/app_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/order.dart';
import 'package:sales/models/order_item.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/models/range_of_dates.dart';
import 'package:sales/services/utils.dart';

import 'database.dart';

class PostgresDatabase extends Database {
  late Connection _connection;

  PostgresDatabase();

  @override
  Future<void> initial() async {
    final postgresSettings = getIt<AppController>().postgresSettings;
    _connection = await Connection.open(
      Endpoint(
        host: postgresSettings.host,
        database: postgresSettings.database,
        username: postgresSettings.username,
        password: postgresSettings.password,
      ),
      settings: postgresSettings.host == 'localhost' ||
              postgresSettings.host == '127.0.0.1'
          ? const ConnectionSettings(sslMode: SslMode.disable)
          : null,
    );
  }

  @override
  Future<void> clear() async {
    await _connection.execute('DELETE FROM order_items');
    await _connection.execute('ALTER SEQUENCE order_items_sequence RESTART');
    await _connection.execute('UPDATE order_items SET oi_id = DEFAULT');
    await _connection.execute('DELETE FROM orders');
    await _connection.execute('ALTER SEQUENCE orders_sequence RESTART');
    await _connection.execute('UPDATE orders SET o_id = DEFAULT');
    await _connection.execute('DELETE FROM products');
    await _connection.execute('ALTER SEQUENCE products_sequence RESTART');
    await _connection.execute('UPDATE products SET p_id = DEFAULT');
    await _connection.execute('DELETE FROM categories');
    await _connection.execute('ALTER SEQUENCE categories_sequence RESTART');
    await _connection.execute('UPDATE categories SET c_id = DEFAULT');
  }

  @override
  Future<void> addCategory(Category category) async {
    const sql =
        'INSERT INTO categories (c_name, c_description) VALUES (@name, @description)';
    await _connection.execute(Sql.named(sql), parameters: {
      'name': category.name,
      'description': category.description,
    });
  }

  @override
  Future<void> updateCategory(Category category) async {
    const sql =
        'UPDATE categories SET c_id = @id, c_name = @name, c_description = @description, c_deleted = @deleted WHERE c_id=@id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': category.id,
      'name': category.name,
      'description': category.description,
      'deleted': category.deleted,
    });
  }

  @override
  Future<void> removeCategory(Category category) async {
    const sql = 'DELETE FROM categories WHERE c_id = @id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': category.id,
    });
  }

  @override
  Future<void> addOrder(Order order) async {
    const sql = 'INSERT INTO orders (c_status, c_date) VALUES (@status, @date)';
    await _connection.execute(Sql.named(sql), parameters: {
      'status': order.status.name,
      'date': TypedValue(Type.date, order.date),
    });
  }

  @override
  Future<void> updateOrder(Order order) async {
    const sql =
        'UPDATE orders SET o_id = @id,  o_status = @status, o_date = @date, o_deleted = @deleted WHERE o_id=@id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': order.id,
      'status': order.status.name,
      'date': order.date,
      'deleted': order.deleted,
    });
  }

  @override
  Future<void> removeOrder(Order order) async {
    const sql = 'DELETE FROM orders WHERE o_id = @id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': order.id,
    });
  }

  @override
  Future<void> addOrderItem(OrderItem orderItem) async {
    const sql =
        'INSERT INTO orders (oi_quantity, oi_unit_sale_price, oi_total_price, oi_product_id, oi_order_id) VALUES (@quantity, @unitSalePrice, @totalPrice, @productId, @orderId)';
    await _connection.execute(Sql.named(sql), parameters: {
      'quantity': orderItem.quantity,
      'unitSalePrice': orderItem.unitSalePrice,
      'totalPrice': orderItem.totalPrice,
      'productId': orderItem.productId,
      'orderId': orderItem.orderId,
    });
  }

  @override
  Future<void> updateOrderItem(OrderItem orderItem) async {
    const sql =
        'UPDATE orders SET oi_id = @id,  oi_quantity = @quantity, oi_unit_sale_price = @unitSalePrice, oi_total_price = @totalPrice, oi_product_id = @productId, oi_order_id = @orderId WHERE oi_id = @id';
    await _connection.execute(Sql.named(sql), parameters: orderItem.toMap());
  }

  @override
  Future<void> removeOrderItem(OrderItem orderItem) async {
    const sql = 'DELETE FROM order_items WHERE oi_id = @id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': orderItem.id,
    });
  }

  @override
  Future<void> addProduct(Product product) async {
    const sql =
        'INSERT INTO products (p_sku, p_name, p_image_path, p_import_price, p_count, p_description, p_category_id) VALUES (@sku, @name, @imagePath, @importPrice, @count, @description, @categoryId)';
    await _connection.execute(Sql.named(sql), parameters: {
      'sku': product.sku,
      'name': product.name,
      'imagePath': TypedValue(Type.varCharArray, product.imagePath),
      'importPrice': product.importPrice,
      'count': product.count,
      'description': product.description,
      'categoryId': product.categoryId,
    });
  }

  @override
  Future<void> updateProduct(Product product) async {
    const sql =
        'UPDATE products SET p_id = @id,  p_sku = @sku, p_name = @name, p_image_path = @imagePath, p_import_price = @importPrice, p_count = @count, p_description = @description, p_category_id = @categoryId, p_deleted = @deleted WHERE p_id=@id';
    await _connection.execute(Sql.named(sql), parameters: product.toMap());
  }

  @override
  Future<void> removeProduct(Product product) async {
    const sql = 'DELETE FROM products WHERE p_id = @id';
    await _connection.execute(Sql.named(sql), parameters: {
      'id': product.id,
    });
  }

  @override
  Future<List<Category>> getAllCategories() async {
    const sql = 'SELECT * FROM categories WHERE c_deleted=FALSE';
    final result = await _connection.execute(sql);
    return result.map((e) => Category.fromSqlMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<OrderItem>> getAllOrderItems() async {
    const sql = 'SELECT * FROM order_items WHERE oi_deleted=FALSE';
    final result = await _connection.execute(sql);
    return result.map((e) => OrderItem.fromSqlMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<Order>> getAllOrders({RangeOfDates? dateRange}) async {
    String sql = 'SELECT * FROM orders WHERE o_deleted=FALSE';
    if (dateRange != null) {
      sql += " AND o_date >= '${Utils.dateToSql(dateRange.from)}'";
      sql += " AND o_date <= '${Utils.dateToSql(dateRange.to)}'";
    }
    final result = await _connection.execute(sql);
    return result.map((e) => Order.fromSqlMap(e.toColumnMap())).toList();
  }

  @override
  Future<List<Product>> getAllProducts({
    ProductOrderBy orderBy = ProductOrderBy.none,
    String searchText = '',
    RangeValues? rangeValues,
    int? categoryId,
  }) async {
    String sql = 'SELECT * FROM products WHERE p_deleted=FALSE';
    Map<String, Object> parameters = {};

    if (categoryId != null) {
      sql += ' AND p_category_id = @categoryId';
      parameters.addAll({'categoryId': categoryId});
    }

    if (rangeValues != null) {
      if (rangeValues.start > 0 && rangeValues.start != double.infinity) {
        sql += ' AND p_import_price >= @minValue';
        parameters.addAll({
          'minValue': rangeValues.start.toInt(),
        });
      }

      if (rangeValues.end > 0 && rangeValues.end != double.infinity) {
        sql += ' AND p_import_price <= @maxValue';
        parameters.addAll({
          'maxValue': rangeValues.end.toInt(),
        });
      }
    }

    // TODO: Tìm cách normalize trước khi query để hiển thị kết quả tốt hơn
    if (searchText.isNotEmpty) {
      sql += ' AND LOWER(p_name) LIKE LOWER(@searchText)';
      parameters.addAll({'searchText': '%$searchText%'});
    }

    sql += ' ORDER BY ${orderBy.sql}';

    final result =
        await _connection.execute(Sql.named(sql), parameters: parameters);
    return result.map((e) => Product.fromSqlMap(e.toColumnMap())).toList();
  }

  @override
  Future<void> saveAllCategories(List<Category> categories) async {
    const sql = 'SELECT * FROM categories WHERE c_id = @id';
    for (final category in categories) {
      final result = await _connection
          .execute(Sql.named(sql), parameters: {'id': category.id});
      if (result.isEmpty) {
        await addCategory(category);
      } else {
        await updateCategory(category);
      }
    }
  }

  @override
  Future<void> saveAllOrderItems(List<OrderItem> orderItems) async {
    const sql = 'SELECT * FROM order_items WHERE oi_id = @id';
    for (final orderItem in orderItems) {
      final result = await _connection
          .execute(Sql.named(sql), parameters: {'id': orderItem.id});
      if (result.isEmpty) {
        await addOrderItem(orderItem);
      } else {
        await updateOrderItem(orderItem);
      }
    }
  }

  @override
  Future<void> saveAllOrders(List<Order> orders) async {
    const sql = 'SELECT * FROM orders WHERE o_id = @id';
    for (final order in orders) {
      final result = await _connection
          .execute(Sql.named(sql), parameters: {'id': order.id});
      if (result.isEmpty) {
        await addOrder(order);
      } else {
        await updateOrder(order);
      }
    }
  }

  @override
  Future<void> saveAllProducts(List<Product> products) async {
    const sql = 'SELECT * FROM products WHERE p_id = @id';
    for (final product in products) {
      final result = await _connection
          .execute(Sql.named(sql), parameters: {'id': product.id});
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
    return result.first.first as int;
  }

  @override
  Future<(int, String)> generateProductIdSku() async {
    const sql = 'SELECT last_value FROM products_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int;
    final id = count + 1;
    return (id, 'P${id.toString().padLeft(8, '0')}');
  }

  @override
  Future<int> generateCategoryId() async {
    const sql = 'SELECT last_value FROM categories_sequence';
    final result = await _connection.execute(sql);
    final count = result.first.first as int;
    final id = count + 1;
    return id;
  }
}
