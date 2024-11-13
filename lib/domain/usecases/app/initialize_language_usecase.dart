import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class InitializeLanguageUseCase implements UseCase<void, NoParams> {

  const InitializeLanguageUseCase(this._repository);
  final LanguageRepository _repository;

  @override
  Future<void> call(NoParams params) {
    return _repository.initialize();
  }
}
