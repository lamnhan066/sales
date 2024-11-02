import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:language_helper/language_helper.dart';

class AppSettingsState with EquatableMixin {
  final LanguageCodes currentlanguage;
  final Set<LanguageCodes> supportedLanguages;
  final Brightness brightness;

  const AppSettingsState({
    this.currentlanguage = LanguageCodes.vi,
    this.supportedLanguages = const {LanguageCodes.vi},
    this.brightness = Brightness.light,
  });

  AppSettingsState copyWith({
    LanguageCodes? currentlanguage,
    Set<LanguageCodes>? supportedLanguages,
    Brightness? brightness,
  }) {
    return AppSettingsState(
      currentlanguage: currentlanguage ?? this.currentlanguage,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  List<Object> get props => [currentlanguage, supportedLanguages, brightness];
}
