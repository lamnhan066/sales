import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/usecases/app/change_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_brightness_usecase.dart';
import 'package:sales/domain/usecases/app/get_current_language_usecase.dart';
import 'package:sales/domain/usecases/app/get_supported_languages_usecase.dart';
import 'package:sales/domain/usecases/app/set_brightness_usecase.dart';
import 'package:sales/presentation/riverpod/states/app_settings_state.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsProvider, AppSettingsState>((ref) {
  return AppSettingsProvider(
    setBrightnessUseCase: getIt(),
    getCurrentBrightnessUseCase: getIt(),
    getCurrentLanguageUseCase: getIt(),
    getSupportedLanguagesUseCase: getIt(),
    changeLanguageUseCase: getIt(),
  );
});

class AppSettingsProvider extends StateNotifier<AppSettingsState> {
  AppSettingsProvider({
    required GetCurrentLanguageUseCase getCurrentLanguageUseCase,
    required GetSupportedLanguagesUseCase getSupportedLanguagesUseCase,
    required ChangeLanguageUseCase changeLanguageUseCase,
    required SetBrightnessUseCase setBrightnessUseCase,
    required this.getCurrentBrightnessUseCase,
  })  : _setBrightnessUseCase = setBrightnessUseCase,
        _changeLanguageUseCase = changeLanguageUseCase,
        _getSupportedLanguagesUseCase = getSupportedLanguagesUseCase,
        _getCurrentLanguageUseCase = getCurrentLanguageUseCase,
        super(const AppSettingsState());

  final GetCurrentLanguageUseCase _getCurrentLanguageUseCase;
  final GetSupportedLanguagesUseCase _getSupportedLanguagesUseCase;
  final ChangeLanguageUseCase _changeLanguageUseCase;
  final SetBrightnessUseCase _setBrightnessUseCase;
  final GetCurrentBrightnessUseCase getCurrentBrightnessUseCase;

  Future<void> initialize() async {
    final currentLanguage = await _getCurrentLanguageUseCase(NoParams());
    final supportedLanguages = await _getSupportedLanguagesUseCase(NoParams());
    final brightness = await getCurrentBrightnessUseCase(NoParams());
    state = state.copyWith(
      currentlanguage: currentLanguage,
      supportedLanguages: supportedLanguages,
      brightness: brightness,
    );
  }

  Future<LanguageCodes> getCurrentLanguage() {
    return _getCurrentLanguageUseCase(NoParams());
  }

  Future<Set<LanguageCodes>> getSupportedLanguages() async {
    return _getSupportedLanguagesUseCase(NoParams());
  }

  Future<void> changeLanguage(LanguageCodes code) async {
    state = state.copyWith(currentlanguage: code);
    await _changeLanguageUseCase(code);
  }

  Future<void> setBrightness(Brightness brightness) async {
    state = state.copyWith(brightness: brightness);
    await _setBrightnessUseCase(brightness);
  }

  Future<Brightness> getCurrentBrightness() {
    return getCurrentBrightnessUseCase(NoParams());
  }
}
