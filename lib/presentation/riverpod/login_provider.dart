import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/usecases/auto_login_usecase.dart';
import 'package:sales/domain/usecases/get_app_version_usecase.dart';
import 'package:sales/domain/usecases/get_login_state_usecase.dart';
import 'package:sales/domain/usecases/get_remember_login_usecase.dart';
import 'package:sales/domain/usecases/load_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/login_usecase.dart';
import 'package:sales/domain/usecases/save_server_configuration_usecase.dart';

class LoginState with EquatableMixin {
  final String username;
  final String password;
  final bool rememberMe;
  final String error;
  final AppVersion version;
  final ServerConfigurations serverConfigurations;
  final bool showAutoLoginDialog;
  final bool isLoggedIn;
  final bool isLoading;

  LoginState({
    required this.username,
    required this.password,
    this.isLoggedIn = false,
    this.rememberMe = false,
    this.error = '',
    this.serverConfigurations = const ServerConfigurations(),
    this.showAutoLoginDialog = false,
    this.isLoading = false,
    this.version = const AppVersion(version: '1.0.0'),
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? rememberMe,
    String? error,
    AppVersion? version,
    ServerConfigurations? serverConfigurations,
    bool? showAutoLoginDialog,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      error: error ?? this.error,
      version: version ?? this.version,
      serverConfigurations: serverConfigurations ?? this.serverConfigurations,
      showAutoLoginDialog: showAutoLoginDialog ?? this.showAutoLoginDialog,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props {
    return [
      username,
      password,
      rememberMe,
      error,
      version,
      serverConfigurations,
      showAutoLoginDialog,
      isLoggedIn,
      isLoading,
    ];
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final AutoLoginUseCase _autoLoginUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;
  final LoadServerConfigurationUseCase _loadServerConfigurationUseCase;
  final SaveServerConfigurationUseCase _saveServerConfigurationUseCase;
  final GetLoginStateUseCase _checkLoginStateUseCase;
  final GetCachedLoginCredentialsLoginUseCase _getCachedLoginCredentialsLoginUseCase;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required AutoLoginUseCase autoLoginUseCase,
    required GetAppVersionUseCase getAppVersionUseCase,
    required LoadServerConfigurationUseCase loadServerConfigurationUseCase,
    required SaveServerConfigurationUseCase saveServerConfigurationUseCase,
    required GetLoginStateUseCase checkLoginStateUseCase,
    required GetCachedLoginCredentialsLoginUseCase getCachedLoginCredentialsLoginUseCase,
  })  : _getAppVersionUseCase = getAppVersionUseCase,
        _autoLoginUseCase = autoLoginUseCase,
        _loginUseCase = loginUseCase,
        _loadServerConfigurationUseCase = loadServerConfigurationUseCase,
        _saveServerConfigurationUseCase = saveServerConfigurationUseCase,
        _checkLoginStateUseCase = checkLoginStateUseCase,
        _getCachedLoginCredentialsLoginUseCase = getCachedLoginCredentialsLoginUseCase,
        super(LoginState(username: '', password: '')) {
    intitial();
  }

  void intitial() async {
    final credentials = await _getCachedLoginCredentialsLoginUseCase(NoParams());
    final isLoggedIn = await _checkLoginStateUseCase(NoParams());
    final rememberMe = _loginUseCase.isRememberMe();
    if (rememberMe) {
      state = state.copyWith(
        username: credentials?.username,
        password: credentials?.password,
        isLoading: false,
        rememberMe: true,
        showAutoLoginDialog: true,
        isLoggedIn: isLoggedIn,
      );
    }
  }

  Future<void> login() async {
    try {
      final credentials = LoginCredentials(
        username: state.username,
        password: state.password,
        rememberMe: state.rememberMe,
      );
      await _loginUseCase.call(credentials);

      state = state.copyWith(username: '', password: '', isLoggedIn: true);
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (_) {
      state = state.copyWith(error: "An unexpected error occurred");
    }
  }

  Future<void> autoLogin() async {
    try {
      final user = await _autoLoginUseCase.call(NoParams());
      state = state.copyWith(username: user.username, password: user.password, isLoggedIn: true);
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void closeAutoLoginDialog() {
    state = state.copyWith(showAutoLoginDialog: false);
  }

  Future<void> loadAppVersion() async {
    final version = await _getAppVersionUseCase.call(NoParams());
    state = state.copyWith(version: version);
  }

  Future<void> loadServerConfigurations() async {
    final configurations = await _loadServerConfigurationUseCase.call(NoParams());
    state = state.copyWith(serverConfigurations: configurations, isLoading: false);
  }

  Future<void> saveServerConfigurations(ServerConfigurations configurations) async {
    await _saveServerConfigurationUseCase.call(configurations);
    state = state.copyWith(serverConfigurations: configurations);
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    loginUseCase: getIt(),
    autoLoginUseCase: getIt(),
    getAppVersionUseCase: getIt(),
    loadServerConfigurationUseCase: getIt(),
    saveServerConfigurationUseCase: getIt(),
    checkLoginStateUseCase: getIt(),
    getCachedLoginCredentialsLoginUseCase: getIt(),
  );
});
