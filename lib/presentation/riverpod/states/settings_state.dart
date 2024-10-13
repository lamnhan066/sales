import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:language_helper/language_helper.dart';

class SettingsState with EquatableMixin {
  final LanguageCodes currentlanguage;
  final Set<LanguageCodes> supportedLanguages;
  final Brightness brightness;
  final int itemPerPage;
  final String backupRestoreStatus;
  final String error;
  final bool isLoading;

  SettingsState({
    this.currentlanguage = LanguageCodes.vi,
    this.supportedLanguages = const {LanguageCodes.vi},
    this.brightness = Brightness.light,
    this.itemPerPage = 0,
    this.backupRestoreStatus = '',
    this.error = '',
    this.isLoading = false,
  });

  SettingsState copyWith({
    LanguageCodes? currentlanguage,
    Set<LanguageCodes>? supportedLanguages,
    Brightness? brightness,
    int? itemPerPage,
    String? backupRestoreStatus,
    String? error,
    bool? isLoading,
  }) {
    return SettingsState(
      currentlanguage: currentlanguage ?? this.currentlanguage,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      brightness: brightness ?? this.brightness,
      itemPerPage: itemPerPage ?? this.itemPerPage,
      backupRestoreStatus: backupRestoreStatus ?? this.backupRestoreStatus,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props {
    return [
      currentlanguage,
      supportedLanguages,
      brightness,
      itemPerPage,
      backupRestoreStatus,
      error,
      isLoading,
    ];
  }
}
