import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _authRepository;

  const LogoutUseCase(this._authRepository);

  @override
  Future<void> call(NoParams params) {
    return _authRepository.logout();
  }
}
