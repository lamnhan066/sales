import 'package:postgres/postgres.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';
import 'package:sales/data/models/order_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/order_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/domain/entities/get_order_params.dart';
import 'package:sales/domain/entities/get_result.dart';

class PostgresOrderImpl implements OrderDatabaseRepository {
  const PostgresOrderImpl(this._core);

  final CoreDatabaseRepository _core;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<void> addAllOrders(List<OrderModel> orders) async {
    await _connection.runTx((session) async {
      for (final item in orders) {
        await addOrder(item, session);
      }
    });
  }

  @override
  Future<int> addOrder(OrderModel order, [Session? session]) async {
    const sql = 'INSERT INTO orders (o_status, o_date, o_deleted) VALUES (@status, @date, FALSE) RETURNING o_id';
    final result = await (session ?? _connection).execute(
      Sql.named(sql),
      parameters: {
        'status': order.status.name,
        'date': TypedValue(Type.timestampTz, order.date),
      },
    );

    return result.first.first as int;
  }

  @override
  Future<List<OrderModel>> getAllOrders({Session? session}) async {
    String sql = 'SELECT * FROM orders';
    final result = await (session ?? _connection).execute(sql);

    return result.map((e) => OrderModel.fromMap(e.toColumnMap())).toList();
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
  Future<GetResult<OrderModel>> getOrders([GetOrderParams params = const GetOrderParams()]) async {
    String sql = 'FROM orders WHERE o_deleted=FALSE';

    // Lọc theo ngày
    final start = params.dateRange?.start;
    final parameters = <String, Object>{};
    if (start != null) {
      sql += " AND o_date >= @startDate";
      parameters.addAll({
        'startDate': TypedValue(Type.timestampTz, start.dateOnly()),
      });
    }

    final end = params.dateRange?.end;
    if (end != null) {
      sql += " AND o_date < @endDate";
      parameters.addAll({
        'endDate': TypedValue(Type.timestampTz, end.dateOnly().add(const Duration(days: 1))),
      });
    }

    // Lấy tổng số đơn hàng.
    final countResult = await _connection.execute(Sql.named('SELECT COUNT(*) $sql'), parameters: parameters);
    final totalCount = countResult.first.first as int;

    sql += ' ORDER BY o_id LIMIT @limit OFFSET @offset';
    parameters.addAll({
      'limit': params.perpage,
      'offset': (params.page - 1) * params.perpage,
    });

    // Lấy danh sách đơn hàng ở trang hiện tại.
    final result = await _connection.execute(Sql.named('SELECT * $sql'), parameters: parameters);
    final orders = result.map((e) => OrderModel.fromMap(e.toColumnMap())).toList();

    return GetResult(
      totalCount: totalCount,
      items: orders,
    );
  }

  @override
  Future<void> removeOrder(OrderModel order, [Session? session]) async {
    await updateOrder(order.copyWith(deleted: true), session);
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
}
