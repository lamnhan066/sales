import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/license_params.dart';
import 'package:sales/domain/repositories/license_repository.dart';

class ActiveLicenseUseCase implements UseCase<License, LicenseParams> {
  final LicenseRepository _repository;

  const ActiveLicenseUseCase(this._repository);

  @override
  Future<License> call(LicenseParams params) {
    return _repository.active(params);
  }
}
