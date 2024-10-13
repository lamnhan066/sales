import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class GetSupportedLanguagesUseCase implements UseCase<Set<LanguageCodes>, NoParams> {
  final LanguageRepository _repository;

  const GetSupportedLanguagesUseCase(this._repository);

  @override
  Future<Set<LanguageCodes>> call(NoParams params) async {
    return _repository.getSupportedLanguages();
  }
}
