import 'package:sales/domain/entities/login_credentials.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(LoginCredentials credentials);
  Future<User> autoLogin();
  Future<void> logout();
  bool isRememberMe();
}
