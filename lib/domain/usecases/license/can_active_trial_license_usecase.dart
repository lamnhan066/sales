import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/license_repository.dart';

class CanActiveTrialLicenseUseCase implements UseCase<bool, User> {

  const CanActiveTrialLicenseUseCase(this._repository);
  final LicenseRepository _repository;

  @override
  Future<bool> call(User user) {
    return _repository.canActiveTrial(user);
  }
}
