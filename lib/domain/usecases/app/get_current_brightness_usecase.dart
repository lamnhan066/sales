import 'dart:async';
import 'dart:ui';

import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/brightness_repository.dart';

class GetCurrentBrightnessUseCase implements UseCase<Brightness, NoParams> {
  final BrightnessRepository _repository;

  const GetCurrentBrightnessUseCase(this._repository);

  @override
  Future<Brightness> call(NoParams params) {
    return _repository.getCurrentBrightness();
  }
}
