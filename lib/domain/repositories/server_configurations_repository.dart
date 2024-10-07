import 'package:sales/domain/entities/server_configurations.dart';

abstract class ServerConfigurationsRepository {
  Future<ServerConfigurations> loadConfigurations();
  Future<void> saveConfigurations(ServerConfigurations settings);
}
