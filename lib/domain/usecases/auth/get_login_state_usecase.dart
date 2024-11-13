import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/auth_repository.dart';

class GetLoginStateUseCase implements UseCase<bool, NoParams> {

  const GetLoginStateUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<bool> call(NoParams params) {
    return _repository.getLoginState();
  }
}
