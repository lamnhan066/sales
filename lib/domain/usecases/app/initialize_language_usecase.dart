import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class InitializeLanguageUseCase implements UseCase<void, NoParams> {
  final LanguageRepository _repository;

  const InitializeLanguageUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.initialize();
  }
}
