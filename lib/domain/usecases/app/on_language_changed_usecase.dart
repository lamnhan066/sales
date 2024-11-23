import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/language_repository.dart';

class OnLanguageChangedUseCase implements UseCase<Stream<LanguageCodes>, NoParams> {
  const OnLanguageChangedUseCase(this._repository);

  final LanguageRepository _repository;

  @override
  Stream<LanguageCodes> call(NoParams params) {
    return _repository.onLanguageChanged();
  }
}
