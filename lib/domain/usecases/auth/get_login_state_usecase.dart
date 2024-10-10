import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class GetLoginStateUseCase implements UseCase<bool, NoParams> {
  final AuthRepository _repository;

  const GetLoginStateUseCase(this._repository);

  @override
  Future<bool> call(NoParams params) {
    return _repository.getLoginState();
  }
}
