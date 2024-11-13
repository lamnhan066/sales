import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostgresConfigurationsRepositoryImpl implements ServerConfigurationsRepository {

  PostgresConfigurationsRepositoryImpl(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  @override
  Future<ServerConfigurations> loadConfigurations() async {
    final postgresSettingsJson = sharedPreferences.getString('PostgresSettings');
    if (postgresSettingsJson != null) {
      return ServerConfigurations.fromJson(postgresSettingsJson);
    }
    return const ServerConfigurations();
  }

  @override
  Future<void> saveConfigurations(ServerConfigurations settings) async {
    await sharedPreferences.setString('PostgresSettings', settings.toJson());
  }
}
