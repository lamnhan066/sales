import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/infrastructure/exceptions/credentials_exception.dart';

class LoginUseCase implements UseCase<User, LoginCredentials> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(LoginCredentials credentials) async {
    try {
      return await repository.login(credentials);
    } on CredentialsException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  bool isRememberMe() {
    return repository.isRememberMe();
  }
}
