import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class GetCurrentLanguageUseCase implements UseCase<LanguageCodes, NoParams> {

  const GetCurrentLanguageUseCase(this._repository);
  final LanguageRepository _repository;

  @override
  Future<LanguageCodes> call(NoParams params) {
    return _repository.getCurrentLanguage();
  }
}
