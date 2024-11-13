import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/entities/user.dart';

class LoginState with EquatableMixin {

  LoginState({
    required this.username,
    required this.password,
    this.rememberMe = false,
    this.error = '',
    this.version = const AppVersion(version: '1.0.0'),
    this.license = const NoLicense(),
    this.licenseError = '',
    this.serverConfigurations = const ServerConfigurations(),
    this.showAutoLoginDialog = true,
    this.isLoggedIn = false,
    this.isLoading = false,
  });
  final String username;
  final String password;
  final bool rememberMe;
  final String error;
  final AppVersion version;
  final License license;
  final String licenseError;
  final ServerConfigurations serverConfigurations;
  final bool showAutoLoginDialog;
  final bool isLoggedIn;
  final bool isLoading;

  User get user => User(username: username, password: password);

  LoginState copyWith({
    String? username,
    String? password,
    bool? rememberMe,
    String? error,
    AppVersion? version,
    License? license,
    String? licenseError,
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
      license: license ?? this.license,
      licenseError: licenseError ?? this.licenseError,
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
      license,
      licenseError,
      serverConfigurations,
      showAutoLoginDialog,
      isLoggedIn,
      isLoading,
    ];
  }
}
