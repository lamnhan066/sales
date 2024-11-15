import 'package:sales/domain/entities/login_credentials.dart';

import 'package:sales/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(LoginCredentials credentials);
  Future<User> autoLogin();
  Future<void> logout();
  bool isRememberMe();
  Future<bool> getLoginState();
  Future<LoginCredentials?> getCachedLoginCredentialsInfomation();
}
