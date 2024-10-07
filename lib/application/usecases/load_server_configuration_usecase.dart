import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/repositories/server_configurations_repository.dart';

class LoadServerConfigurationUseCase implements UseCase<ServerConfigurations, NoParams> {
  final ServerConfigurationsRepository _repository;

  LoadServerConfigurationUseCase(this._repository);

  @override
  Future<ServerConfigurations> call(NoParams _) async {
    return await _repository.loadConfigurations();
  }
}
