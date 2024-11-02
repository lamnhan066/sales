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
    required this.getCurrentLanguageUseCase,
    required this.getSupportedLanguagesUseCase,
    required this.changeLanguageUseCase,
    required this.setBrightnessUseCase,
    required this.getCurrentBrightnessUseCase,
  }) : super(AppSettingsState());

  final GetCurrentLanguageUseCase getCurrentLanguageUseCase;
  final GetSupportedLanguagesUseCase getSupportedLanguagesUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;
  final SetBrightnessUseCase setBrightnessUseCase;
  final GetCurrentBrightnessUseCase getCurrentBrightnessUseCase;

  Future<void> initialize() async {
    final currentLanguage = await getCurrentLanguageUseCase(NoParams());
    final supportedLanguages = await getSupportedLanguagesUseCase(NoParams());
    final brightness = await getCurrentBrightnessUseCase(NoParams());
    state = state.copyWith(
      currentlanguage: currentLanguage,
      supportedLanguages: supportedLanguages,
      brightness: brightness,
    );
  }

  Future<LanguageCodes> getCurrentLanguage() {
    return getCurrentLanguageUseCase(NoParams());
  }

  Future<Set<LanguageCodes>> getSupportedLanguages() async {
    return getSupportedLanguagesUseCase(NoParams());
  }

  Future<void> changeLanguage(LanguageCodes code) async {
    state = state.copyWith(currentlanguage: code);
    await changeLanguageUseCase(code);
  }

  Future<void> setBrightness(Brightness brightness) async {
    state = state.copyWith(brightness: brightness);
    await setBrightnessUseCase(brightness);
  }

  Future<Brightness> getCurrentBrightness() {
    return getCurrentBrightnessUseCase(NoParams());
  }
}
