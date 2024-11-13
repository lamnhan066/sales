import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/license_repository.dart';

class GetLicenseUseCase implements UseCase<License, User> {

  const GetLicenseUseCase(this._repository);
  final LicenseRepository _repository;

  @override
  Future<License> call(User user) {
    return _repository.getLicense(user);
  }
}
