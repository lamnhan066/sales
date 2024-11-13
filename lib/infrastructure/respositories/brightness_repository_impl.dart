import 'dart:ui';

import 'package:sales/domain/repositories/brightness_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessRepositoryImpl implements BrightnessRepository {
  const BrightnessRepositoryImpl(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<Brightness> getCurrentBrightness() async {
    return (_prefs.getBool('AppBrightness') ?? false) ? Brightness.dark : Brightness.light;
  }

  @override
  Future<void> setBrightness(Brightness brightness) async {
    await _prefs.setBool('AppBrightness', brightness == Brightness.dark);
  }
}
