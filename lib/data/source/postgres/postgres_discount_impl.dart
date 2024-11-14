import 'dart:math';

import 'package:postgres/postgres.dart';
import 'package:sales/data/models/discount_model.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/data/repositories/discount_database_repository.dart';
import 'package:sales/data/source/postgres/postgres_core_impl.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/domain/entities/get_result.dart';
import 'package:sales/domain/entities/pagination_params.dart';

class PostgresDiscountImpl implements DiscountDatabaseRepository {
  PostgresDiscountImpl(this._core);

  final CoreDatabaseRepository _core;
  Connection get _connection => (_core as PostgresCoreImpl).connection;

  @override
  Future<DiscountModel?> getDiscountByCode(String code) async {
    const sql = 'SELECT * FROM discounts WHERE dc_code = @code AND dc_order_id = -1';
    final result = await _connection.execute(Sql.named(sql), parameters: {'code': code});
    if (result.isEmpty) {
      return null;
    }
    return DiscountModel.fromMap(result.first.toColumnMap());
  }

  @override
  Future<List<DiscountModel>> getDiscountByOrderid(int id) async {
    const sql = 'SELECT * FROM discounts WHERE dc_order_id = @orderId';
    final result = await _connection.execute(Sql.named(sql), parameters: {'orderId': id});
    return result.map((e) => DiscountModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<void> addDiscountPercent(AddDiscountParams params) async {
    const sql = 'INSERT INTO discounts (dc_code, dc_percent, dc_max_price) VALUES (@code, @percent, @maxPrice)';
    await _connection.runTx((session) async {
      for (var i = 0; i < params.numberOfDiscounts; i++) {
        final code = await generateDiscountCode(session);
        await session.execute(
          Sql.named(sql),
          parameters: {
            'code': code,
            'percent': params.percent,
            'maxPrice': params.maxPrice,
          },
        );
      }
    });
  }

  @override
  Future<void> updateDiscount(DiscountModel discount) async {
    const sql =
        'UPDATE discounts SET dc_code = @code, dc_order_id = @orderId, dc_percent = @percent, dc_max_price = @maxPrice WHERE dc_id = @id';
    await _connection.execute(
      Sql.named(sql),
      parameters: {
        'code': discount.code,
        'orderId': discount.orderId,
        'percent': discount.percent,
        'maxPrice': discount.maxPrice,
        'id': discount.id,
      },
    );
  }

  @override
  Future<void> removeUnusedDiscount(DiscountModel discount) async {
    const sql = 'DELETE FROM discounts WHERE dc_id = @id AND dc_order_id = -1';
    await _connection.execute(
      Sql.named(sql),
      parameters: {
        'id': discount.id,
      },
    );
  }

  @override
  Future<GetResult<DiscountModel>> getAllAvailableDiscounts(PaginationParams params) async {
    var sql = 'FROM discounts WHERE dc_order_id = -1';
    final countResult = await _connection.execute(
      Sql.named('SELECT COUNT(*) $sql'),
    );
    final totalCount = countResult.first.first! as int;

    if (totalCount == 0) return GetResult(totalCount: totalCount, items: []);

    sql += ' LIMIT @limit OFFSET @offset';
    final result = await _connection.execute(
      Sql.named('SELECT * $sql'),
      parameters: {
        'limit': params.perpage,
        'offset': (params.page - 1) * params.perpage,
      },
    );

    return GetResult(
      totalCount: totalCount,
      items: result.map((e) => DiscountModel.fromMap(e.toColumnMap())).toList(),
    );
  }

  @override
  Future<List<DiscountModel>> getAllDiscounts() async {
    const sql = 'SELECT * FROM discounts';
    final result = await _connection.execute(sql);
    return result.map((e) => DiscountModel.fromMap(e.toColumnMap())).toList();
  }

  @override
  Future<void> addAllDiscounts(List<DiscountModel> discounts) async {
    const sql = 'INSERT INTO discounts (dc_code, dc_percent, dc_max_price) VALUES (@code, @percent, @maxPrice)';
    await _connection.runTx((session) async {
      for (final discount in discounts) {
        await session.execute(
          Sql.named(sql),
          parameters: {
            'code': discount.code,
            'percent': discount.percent,
            'maxPrice': discount.maxPrice,
          },
        );
      }
    });
  }

  Future<String> generateDiscountCode(TxSession session) async {
    const sql = 'SELECT * FROM discounts WHERE dc_code = @code';
    final data = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split('');
    final buffer = StringBuffer();
    final random = Random();

    Future<bool> isCodeExists() async {
      final result = await session.execute(
        Sql.named(sql),
        parameters: {
          'code': buffer.toString(),
        },
      );
      return result.isNotEmpty;
    }

    do {
      buffer.clear();
      for (var i = 0; i < 6; i++) {
        buffer.write(data.elementAt(random.nextInt(data.length)));
      }
    } while (await isCodeExists());

    return buffer.toString();
  }
}
