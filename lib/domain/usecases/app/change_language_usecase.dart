import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class ChangeLanguageUseCase implements UseCase<void, LanguageCodes> {
  final LanguageRepository _repository;

  const ChangeLanguageUseCase(this._repository);

  @override
  Future<void> call(LanguageCodes code) {
    return _repository.changeLanguage(code);
  }
}
