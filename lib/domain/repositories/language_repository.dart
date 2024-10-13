import 'package:language_helper/language_helper.dart';

abstract interface class LanguageRepository {
  Future<void> initialize();
  Future<Set<LanguageCodes>> getSupportedLanguages();
  Future<LanguageCodes> getCurrentLanguage();
  Future<void> changeLanguage(LanguageCodes code);
}
