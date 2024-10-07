import 'package:language_helper/language_helper.dart';
import 'package:sales/core/utils/password_cryptor.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/exceptions/invalid_cache_credentials_exception.dart';
import 'package:sales/domain/exceptions/invalid_credentials_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';

class LocalAuthRepositoryImpl implements AuthRepository {
  final SharedPreferences prefs;

  LocalAuthRepositoryImpl(this.prefs);

  @override
  Future<User> login(LoginCredentials credentials) async {
    if (credentials.username != 'admin' || credentials.password != '0000') {
      throw InvalidCredentialsException('Sai tên đăng nhập hoặc mật khẩu'.tr);
    }

    if (credentials.rememberMe) {
      await saveRememberedCredentials(credentials);
    } else {
      await removeRememberedCredentials();
    }

    return User(username: credentials.username, password: credentials.password);
  }

  @override
  Future<User> autoLogin() async {
    final credentials = getRememberedCredentials();
    if (credentials == null) {
      throw InvalidCacheCredentialsException('Không có thông tin đăng nhập được lưu'.tr);
    }
    return login(credentials);
  }

  @override
  Future<void> logout() async {
    /* Logout không cần xử lý khi đăng nhập ở local */
  }

  @override
  bool isRememberMe() {
    return prefs.containsKey('LoginCredentials');
  }

  LoginCredentials? getRememberedCredentials() {
    if (!prefs.containsKey('LoginCredentials')) {
      return null;
    }

    var credentials = LoginCredentials.fromJson(prefs.getString('LoginCredentials')!);
    final decryptedPassword = PasswordCryptor.decryptPassword(credentials);
    credentials = credentials.copyWith(password: decryptedPassword);

    return credentials;
  }

  Future<void> saveRememberedCredentials(LoginCredentials credentials) async {
    final encryptedPassword = PasswordCryptor.encryptPassword(credentials);
    credentials = credentials.copyWith(password: encryptedPassword);
    await prefs.setString('LoginCredentials', credentials.toJson());
  }

  Future<void> removeRememberedCredentials() async {
    await prefs.remove('LoginCredentials');
  }
}
