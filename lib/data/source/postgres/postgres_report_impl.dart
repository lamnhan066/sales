import 'package:postgres/postgres.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/data/models/get_orders_result_model.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/models/product_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/order_database_repository.dart';
import 'package:sales/data/repositories/order_item_database_repository.dart';
import 'package:sales/data/repositories/report_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/ranges.dart';

class PostgresReportImpl implements ReportDatabaseRepository {
  const PostgresReportImpl(this._core, this._order, this._orderItem);

  final CoreDatabaseRepository _core;
  final OrderDatabaseRepository _order;
  final OrderItemDatabaseRepository _orderItem;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<int> getDailyOrderCount(DateTime dateTime) async {
    final orders = await _order.getOrders(GetOrderParams(dateRange: Ranges(dateTime, dateTime)));
    return orders.items.length;
  }

  @override
  Future<int> getDailyRevenue(DateTime dateTime) async {
    final orders = await _order.getOrders(GetOrderParams(dateRange: Ranges(dateTime, dateTime)));
    var total = 0;
    for (final order in orders.items) {
      final items = await _orderItem.getOrderItems(GetOrderItemsParams(orderId: order.id));
      for (final item in items) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  @override
  Future<List<int>> getDailyRevenueForMonth(DateTime dateTime) async {
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
          o_deleted = FALSE AND oi_deleted = FALSE AND p_deleted = FALSE AND DATE_TRUNC('month', o_date::timestamp) = DATE_TRUNC('month', @currentDate::timestamp)
      GROUP BY 
          TO_CHAR(o_date, 'DD')
      ORDER BY 
          day ASC;
    ''';
    final result = await _connection.execute(Sql.named(sql), parameters: {'currentDate': dateTime});
    final mapResult = <int, int>{};
    for (final e in result) {
      final map = e.toColumnMap();
      final day = int.parse(map['day']);
      final total = map['total_revenue'] as int;
      mapResult.putIfAbsent(day, () => 0);
      mapResult[day] = mapResult[day]! + total;
    }
    final listResult = <int>[];
    for (var i = 1; i <= dateTime.day; i++) {
      listResult.add(mapResult[i] ?? 0);
    }
    return listResult;
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
    final maps = <ProductModel, int>{};
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
  Future<int> getProfit(Ranges<DateTime> params) async {
    const sql = '''
      SELECT
          SUM((oi_unit_sale_price - p_import_price) * oi_quantity) AS profit
      FROM
          order_items
      JOIN
          products ON oi_product_id = p_id
      JOIN
          orders ON oi_order_id = o_id
      WHERE
          oi_deleted = FALSE AND p_deleted = FALSE AND o_deleted= FALSE AND o_date >= @startDate AND o_date <= @endDate
    ''';
    final parameters = {
      'startDate': params.start.dateOnly(),
      'endDate': params.end.dateOnly().add(const Duration(days: 1)),
    };

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    return (result.first.first as int?) ?? 0;
  }

  @override
  Future<int> getRevenue(Ranges<DateTime> params) async {
    const sql = '''
      SELECT
          SUM(oi_total_price) AS total_price
      FROM
          orders
      JOIN
          order_items ON o_id = oi_order_id
      WHERE
          o_deleted = FALSE AND oi_deleted = FALSE AND o_date >= @startDate AND o_date < @endDate
    ''';
    final parameters = {
      'startDate': params.start.dateOnly(),
      'endDate': params.end.dateOnly().add(const Duration(days: 1)),
    };

    final result = await _connection.execute(Sql.named(sql), parameters: parameters);
    return (result.first.first as int?) ?? 0;
  }

  @override
  Future<Map<ProductModel, int>> getSoldProductsWithQuantity(Ranges<DateTime> dateRange) async {
    const sql = '''
      SELECT
          *, SUM(oi_quantity) AS total_quantity
      FROM
          order_items
      JOIN 
          products ON oi_product_id = p_id
      JOIN
          orders ON oi_order_id = o_id
      WHERE
          p_deleted = FALSE AND o_deleted = FALSE AND o_date >= @startDate AND o_date < @endDate
      GROUP BY
          p_id, oi_id, o_id
      ORDER BY
          o_date
    ''';
    final parameters = {
      'startDate': dateRange.start.dateOnly(),
      'endDate': dateRange.end.dateOnly().add(const Duration(days: 1)),
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
  Future<RecentOrdersResultModel> getThreeRecentOrders() async {
    const sql = '''
      SELECT 
        *
      FROM 
        (
          SELECT 
            *
          FROM 
            orders
          WHERE 
            o_deleted = FALSE
          ORDER BY
            o_date DESC
          LIMIT
            3
        ) AS recent_orders
      JOIN
        order_items ON oi_order_id = recent_orders.o_id
      JOIN
        products ON oi_product_id = p_id
      WHERE 
        oi_deleted = FALSE AND p_deleted = FALSE
      ORDER BY
        o_date DESC
    ''';
    final result = await _connection.execute(sql);
    final products = <OrderModel, List<ProductModel>>{};
    final orderItems = <OrderModel, List<OrderItemModel>>{};
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
}
