import 'dart:ui';

abstract interface class BrightnessRepository {
  Future<Brightness> getCurrentBrightness();
  Future<void> setBrightness(Brightness brightness);
}
