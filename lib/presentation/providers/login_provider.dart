import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/application/usecases/auto_login_usecase.dart';
import 'package:sales/application/usecases/get_app_version_usecase.dart';
import 'package:sales/application/usecases/login_usecase.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/entities/login_credentials.dart';

class LoginState {
  final String username;
  final String password;
  final bool rememberMe;
  final String error;
  final AppVersion version;
  final bool showAutoLoginDialog;
  final bool isLoggedIn;

  LoginState({
    required this.username,
    required this.password,
    this.isLoggedIn = false,
    this.rememberMe = false,
    this.error = '',
    this.showAutoLoginDialog = true,
    this.version = const AppVersion(version: '1.0.0'),
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? rememberMe,
    String? error,
    AppVersion? version,
    bool? showAutoLoginDialog,
    bool? isLoggedIn,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      error: error ?? this.error,
      version: version ?? this.version,
      showAutoLoginDialog: showAutoLoginDialog ?? this.showAutoLoginDialog,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;
  final AutoLoginUseCase autoLoginUseCase;
  final GetAppVersionUseCase getAppVersionUseCase;

  LoginNotifier({
    required this.loginUseCase,
    required this.autoLoginUseCase,
    required this.getAppVersionUseCase,
  }) : super(LoginState(username: '', password: ''));

  void intitial() {
    state = state.copyWith(rememberMe: loginUseCase.isRememberMe());
  }

  Future<void> login() async {
    try {
      final credentials = LoginCredentials(
        username: state.username,
        password: state.password,
        rememberMe: state.rememberMe,
      );
      await loginUseCase.call(credentials);

      state = state.copyWith(isLoggedIn: true);
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (_) {
      state = state.copyWith(error: "An unexpected error occurred");
    }
  }

  Future<void> autoLogin() async {
    try {
      final user = await autoLoginUseCase.call(NoParams());
      state = state.copyWith(username: user.username, password: user.password, isLoggedIn: true);
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false);
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
    final version = await getAppVersionUseCase.call(NoParams());
    state = state.copyWith(version: version);
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    loginUseCase: getIt<LoginUseCase>(),
    autoLoginUseCase: getIt<AutoLoginUseCase>(),
    getAppVersionUseCase: getIt<GetAppVersionUseCase>(),
  );
});
