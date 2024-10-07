import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';

class SaveServerConfigurationUseCase implements UseCase<void, ServerConfigurations> {
  final ServerConfigurationsRepository _repository;

  SaveServerConfigurationUseCase(this._repository);

  @override
  Future<void> call(ServerConfigurations configurations) async {
    await _repository.saveConfigurations(configurations);
  }
}
