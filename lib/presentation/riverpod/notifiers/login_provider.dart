import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/license_params.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/entities/server_configurations.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/usecases/app/get_app_version_usecase.dart';
import 'package:sales/domain/usecases/auth/auto_login_usecase.dart';
import 'package:sales/domain/usecases/auth/get_cached_credentials_usecase.dart';
import 'package:sales/domain/usecases/auth/get_login_state_usecase.dart';
import 'package:sales/domain/usecases/auth/login_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/data_services/load_server_connection_usecase.dart';
import 'package:sales/domain/usecases/data_services/save_server_configuration_usecase.dart';
import 'package:sales/domain/usecases/license/active_license_usecase.dart';
import 'package:sales/domain/usecases/license/active_trial_license_usecase.dart';
import 'package:sales/domain/usecases/license/can_active_trial_license_usecase.dart';
import 'package:sales/domain/usecases/license/get_license_usecase.dart';
import 'package:sales/presentation/riverpod/states/login_state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    loginUseCase: getIt(),
    autoLoginUseCase: getIt(),
    getAppVersionUseCase: getIt(),
    loadServerConfigurationUseCase: getIt(),
    saveServerConfigurationUseCase: getIt(),
    checkLoginStateUseCase: getIt(),
    getCachedLoginCredentialsLoginUseCase: getIt(),
    loadServerConnectionUsecase: getIt(),
    canActiveTrialLicenseUseCase: getIt(),
    activeLicenseUseCase: getIt(),
    activeTrialLicenseUseCase: getIt(),
    getLicenseUseCase: getIt(),
  );
});

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final AutoLoginUseCase _autoLoginUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;
  final LoadServerConfigurationUseCase _loadServerConfigurationUseCase;
  final SaveServerConfigurationUseCase _saveServerConfigurationUseCase;
  final GetLoginStateUseCase _checkLoginStateUseCase;
  final GetCachedCredentialsUseCase _getCachedLoginCredentialsLoginUseCase;
  final LoadServerConnectionUsecase _loadServerConnectionUsecase;
  final GetLicenseUseCase _getLicenseUseCase;
  final CanActiveTrialLicenseUseCase _canActiveTrialLicenseUseCase;
  final ActiveTrialLicenseUseCase _activeTrialLicenseUseCase;
  final ActiveLicenseUseCase _activeLicenseUseCase;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required AutoLoginUseCase autoLoginUseCase,
    required GetAppVersionUseCase getAppVersionUseCase,
    required LoadServerConfigurationUseCase loadServerConfigurationUseCase,
    required SaveServerConfigurationUseCase saveServerConfigurationUseCase,
    required GetLoginStateUseCase checkLoginStateUseCase,
    required GetCachedCredentialsUseCase getCachedLoginCredentialsLoginUseCase,
    required LoadServerConnectionUsecase loadServerConnectionUsecase,
    required GetLicenseUseCase getLicenseUseCase,
    required CanActiveTrialLicenseUseCase canActiveTrialLicenseUseCase,
    required ActiveTrialLicenseUseCase activeTrialLicenseUseCase,
    required ActiveLicenseUseCase activeLicenseUseCase,
  })  : _getAppVersionUseCase = getAppVersionUseCase,
        _autoLoginUseCase = autoLoginUseCase,
        _loginUseCase = loginUseCase,
        _loadServerConfigurationUseCase = loadServerConfigurationUseCase,
        _saveServerConfigurationUseCase = saveServerConfigurationUseCase,
        _checkLoginStateUseCase = checkLoginStateUseCase,
        _getCachedLoginCredentialsLoginUseCase = getCachedLoginCredentialsLoginUseCase,
        _loadServerConnectionUsecase = loadServerConnectionUsecase,
        _activeLicenseUseCase = activeLicenseUseCase,
        _activeTrialLicenseUseCase = activeTrialLicenseUseCase,
        _canActiveTrialLicenseUseCase = canActiveTrialLicenseUseCase,
        _getLicenseUseCase = getLicenseUseCase,
        super(LoginState(username: '', password: ''));

  Future<void> initialize() async {
    final credentials = await _getCachedLoginCredentialsLoginUseCase(NoParams());
    final isLoggedIn = await _checkLoginStateUseCase(NoParams());
    await loadServerConfigurations();
    final rememberMe = _loginUseCase.isRememberMe();
    if (rememberMe) {
      final license = await _getLicenseUseCase(
        User(username: credentials?.username ?? '', password: credentials?.password ?? ''),
      );
      state = state.copyWith(
        username: credentials?.username,
        password: credentials?.password,
        isLoading: false,
        rememberMe: true,
        license: license,
        showAutoLoginDialog: true,
        isLoggedIn: isLoggedIn,
      );
    }
  }

  Future<bool> login() async {
    state = state.copyWith(error: '');
    try {
      final credentials = LoginCredentials(
        username: state.username,
        password: state.password,
        rememberMe: state.rememberMe,
      );
      final user = await _loginUseCase.call(credentials);
      state = state.copyWith(isLoggedIn: true);
      final license = await _getLicenseUseCase(user);
      if (license is NoLicense || license.isExpired) {
        state = state.copyWith(error: 'Vui lòng kích hoạt bản quyền để tiếp tục sử dụng'.tr, license: license);
        return false;
      }
      await reloadServer();
      if (state.rememberMe) {
        state = state.copyWith(license: license, isLoggedIn: true);
      } else {
        state = state.copyWith(username: '', password: '', license: license, isLoggedIn: true);
      }

      return true;
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (_) {
      state = state.copyWith(error: 'Đã có lỗi không xác định!'.tr);
    }

    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final user = await _autoLoginUseCase.call(NoParams());
      state = state.copyWith(isLoggedIn: true);
      final license = await _getLicenseUseCase(user);
      if (license is NoLicense || license.isExpired) {
        state = state.copyWith(error: 'Vui lòng kích hoạt bản quyền để tiếp tục sử dụng'.tr, license: license);
        return false;
      }
      await reloadServer();
      if (state.rememberMe) {
        state = state.copyWith(license: license, isLoggedIn: true);
      } else {
        state = state.copyWith(username: '', password: '', license: license, isLoggedIn: true);
      }

      return true;
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    } catch (_) {
      state = state.copyWith(error: 'Đã có lỗi không xác định!'.tr);
    }

    return false;
  }

  Future<void> reloadServer() async {
    var configurations = await _loadServerConfigurationUseCase.call(NoParams());
    configurations = configurations.copyWith(username: state.username, password: state.password);
    state = state.copyWith(serverConfigurations: configurations);
    await _saveServerConfigurationUseCase.call(configurations);
    await loadServerConfigurations();
    await _loadServerConnectionUsecase(NoParams());
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
    final configs = configurations.copyWith(username: state.username, password: state.password);
    state = state.copyWith(serverConfigurations: configs);
    await _saveServerConfigurationUseCase.call(configs);
  }

  Future<bool> canActiveTrial() {
    return _canActiveTrialLicenseUseCase(state.user);
  }

  Future<void> activeTrial() async {
    if (!await canActiveTrial()) {
      state = state.copyWith(licenseError: 'Không thể kích hoạt bản dùng thử'.tr);
      return;
    }

    final license = await _activeTrialLicenseUseCase(state.user);
    if (license is! NoLicense) {
      state = state.copyWith(license: license, licenseError: '');
    } else {
      state = state.copyWith(
        license: license,
        licenseError: 'Không thể kích hoạt bản dùng thử'.tr,
      );
    }
  }

  Future<void> active(String code) async {
    final license = await _activeLicenseUseCase(LicenseParams(user: state.user, code: code));
    if (license is! NoLicense) {
      state = state.copyWith(license: license, licenseError: '', error: '');
    } else {
      state = state.copyWith(
        license: license,
        licenseError: 'Không thể kích hoạt với mã đã nhập'.tr,
      );
    }
  }
}
