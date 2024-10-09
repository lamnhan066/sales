import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class GetCachedCredentialsUseCase extends UseCase<LoginCredentials?, NoParams> {
  final AuthRepository _repository;

  GetCachedCredentialsUseCase(this._repository);

  @override
  Future<LoginCredentials?> call(NoParams params) {
    return _repository.getCachedLoginCredentialsInfomation();
  }
}
