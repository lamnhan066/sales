import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/repositories/language_repository.dart';
import 'package:sales/presentation/languages/language_helper/language_data.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageHelper _languageHelper;

  const LanguageRepositoryImpl(this._languageHelper);

  @override
  Future<void> initialize() async {
    await _languageHelper.initial(data: [LanguageDataProvider.data(languageData)]);
  }

  @override
  Future<void> changeLanguage(LanguageCodes code) async {
    await _languageHelper.change(code);
  }

  @override
  Future<LanguageCodes> getCurrentLanguage() async {
    return _languageHelper.code;
  }

  @override
  Future<Set<LanguageCodes>> getSupportedLanguages() async {
    return _languageHelper.codes;
  }
}
