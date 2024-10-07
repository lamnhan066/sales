import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/application/usecases/load_server_configuration_usecase.dart';
import 'package:sales/application/usecases/save_server_configuration_usecase.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/server_configurations.dart';

class ServerConfigurationState {
  final ServerConfigurations configurations;
  final bool showDialog;
  final bool isInitialized;

  ServerConfigurationState({
    required this.configurations,
    this.showDialog = false,
    this.isInitialized = false,
  });

  ServerConfigurationState copyWith({
    ServerConfigurations? configurations,
    bool? showConfigDialog,
    bool? isInitialized,
  }) {
    return ServerConfigurationState(
      configurations: configurations ?? this.configurations,
      showDialog: showConfigDialog ?? showDialog,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class ServerConfigurationNotifier extends StateNotifier<ServerConfigurationState> {
  final LoadServerConfigurationUseCase _loadServerConfigurationUseCase;
  final SaveServerConfigurationUseCase _saveServerConfigurationUseCase;

  ServerConfigurationNotifier(this._loadServerConfigurationUseCase, this._saveServerConfigurationUseCase)
      : super(
          ServerConfigurationState(
            configurations: ServerConfigurations(
              host: 'localhost',
              database: 'postgres',
              username: 'postgres',
              password: 'sales',
            ),
          ),
        );

  void requestServerConfigurationDialog() {
    state = state.copyWith(showConfigDialog: true);
  }

  Future<void> loadConfigurations() async {
    final configurations = await _loadServerConfigurationUseCase.call(NoParams());
    state = state.copyWith(configurations: configurations, isInitialized: true);
  }

  Future<void> saveConfigurations(ServerConfigurations configurations) async {
    await _saveServerConfigurationUseCase.call(configurations);
    state = state.copyWith(configurations: configurations, showConfigDialog: false);
  }

  void closeDialog() {
    state = state.copyWith(showConfigDialog: false);
  }
}

final postgresConfigurationsProvider =
    StateNotifierProvider<ServerConfigurationNotifier, ServerConfigurationState>((ref) {
  return ServerConfigurationNotifier(getIt(), getIt());
});
