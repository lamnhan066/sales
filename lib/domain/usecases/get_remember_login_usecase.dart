import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/login_credentials.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class GetCachedLoginCredentialsLoginUseCase extends UseCase<LoginCredentials?, NoParams> {
  final AuthRepository _repository;

  GetCachedLoginCredentialsLoginUseCase(this._repository);

  @override
  Future<LoginCredentials?> call(NoParams params) {
    return _repository.getCachedLoginCredentialsInfomation();
  }
}
