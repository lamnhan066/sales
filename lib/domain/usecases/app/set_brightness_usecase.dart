import 'dart:async';
import 'dart:ui';

import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/brightness_repository.dart';

class SetBrightnessUseCase implements UseCase<void, Brightness> {

  const SetBrightnessUseCase(this._repository);
  final BrightnessRepository _repository;

  @override
  Future<void> call(Brightness brightness) async {
    await _repository.setBrightness(brightness);
  }
}
