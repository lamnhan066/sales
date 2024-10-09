import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostgresConfigurationsRepositoryImpl implements ServerConfigurationsRepository {
  final SharedPreferences sharedPreferences;

  PostgresConfigurationsRepositoryImpl(this.sharedPreferences);

  @override
  Future<ServerConfigurations> loadConfigurations() async {
    final postgresSettingsJson = sharedPreferences.getString('PostgresSettings');
    if (postgresSettingsJson != null) {
      return ServerConfigurations.fromJson(postgresSettingsJson);
    }
    return const ServerConfigurations(
      host: 'localhost',
      database: 'postgres',
      username: 'postgres',
      password: 'sales',
    );
  }

  @override
  Future<void> saveConfigurations(ServerConfigurations settings) async {
    await sharedPreferences.setString('PostgresSettings', settings.toJson());
  }
}
