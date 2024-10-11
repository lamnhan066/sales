import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/entities/server_configurations.dart';

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
