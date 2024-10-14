import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/auth_repository.dart';
import 'package:sales/infrastructure/exceptions/credentials_exception.dart';

class AutoLoginUseCase implements UseCase<User, NoParams> {
  final AuthRepository _repository;

  const AutoLoginUseCase(this._repository);

  @override
  Future<User> call(NoParams _) async {
    try {
      return await _repository.autoLogin();
    } on CredentialsException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
