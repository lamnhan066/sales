import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/license_repository.dart';

class ActiveTrialLicenseUseCase implements UseCase<License, User> {
  final LicenseRepository _repository;

  const ActiveTrialLicenseUseCase(this._repository);

  @override
  Future<License> call(User user) {
    return _repository.activeTrial(user);
  }
}
