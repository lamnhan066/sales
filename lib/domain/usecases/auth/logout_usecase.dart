import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {

  const LogoutUseCase(this._authRepository);
  final AuthRepository _authRepository;

  @override
  Future<void> call(NoParams params) {
    return _authRepository.logout();
  }
}
