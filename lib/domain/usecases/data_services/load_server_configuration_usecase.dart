import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';

class LoadServerConfigurationUseCase implements UseCase<ServerConfigurations, NoParams> {

  LoadServerConfigurationUseCase(this._repository);
  final ServerConfigurationsRepository _repository;

  @override
  Future<ServerConfigurations> call(NoParams _) async {
    final configurations = await _repository.loadConfigurations();
    return configurations;
  }
}
