import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class GetCachedCredentialsUseCase extends UseCase<LoginCredentials?, NoParams> {

  GetCachedCredentialsUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<LoginCredentials?> call(NoParams params) {
    return _repository.getCachedLoginCredentialsInfomation();
  }
}
