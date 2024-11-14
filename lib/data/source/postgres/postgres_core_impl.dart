import 'dart:async';

import 'package:postgres/postgres.dart';
import 'package:sales/data/repositories/core_database_repository.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';

class PostgresCoreImpl implements CoreDatabaseRepository {
  PostgresCoreImpl(this._serverConfigurationRepository);
  final ServerConfigurationsRepository _serverConfigurationRepository;

  late Connection _connection;
  Connection get connection => _connection;

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
    await connection.close();
  }

  @override
  Future<void> clear() async {
    await connection.runTx((session) async {
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
      await session.execute('DELETE FROM discounts');
      await session.execute('ALTER SEQUENCE discounts_sequence RESTART');
      await session.execute('UPDATE discounts SET dc_id = DEFAULT');
    });
  }
}
