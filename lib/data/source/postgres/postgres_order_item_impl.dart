import 'package:postgres/postgres.dart';
import 'package:sales/data/models/order_item_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/order_item_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/domain/entities/get_order_items_params.dart';

class PostgresOrderItemImpl implements OrderItemDatabaseRepository {
  const PostgresOrderItemImpl(this._core);

  final CoreDatabaseRepository _core;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<void> addAllOrderItems(List<OrderItemModel> orderItems) async {
    _connection.runTx((session) async {
      for (final item in orderItems) {
        await addOrderItem(item, session);
      }
    });
  }

  @override
  Future<void> addOrderItem(OrderItemModel orderItem, [Session? session]) async {
    const sql =
        'INSERT INTO order_items (oi_quantity, oi_unit_sale_price, oi_total_price, oi_product_id, oi_order_id, oi_deleted) VALUES (@quantity, @unitSalePrice, @totalPrice, @productId, @orderId, FALSE)';
    await (session ?? _connection).execute(
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
  Future<List<OrderItemModel>> getAllOrderItems([Session? session]) async {
    var sql = 'SELECT * FROM order_items';
    final result = await (session ?? _connection).execute(sql);
    return result.map((e) => OrderItemModel.fromMap(e.toColumnMap())).toList();
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
  Future<void> removeOrderItem(OrderItemModel orderItem, [Session? session]) async {
    await updateOrderItem(orderItem.copyWith(deleted: true), session);
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
}
