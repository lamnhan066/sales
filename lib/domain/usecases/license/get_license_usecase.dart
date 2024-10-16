import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/license_repository.dart';

class GetLicenseUseCase implements UseCase<License, User> {
  final LicenseRepository _repository;

  const GetLicenseUseCase(this._repository);

  @override
  Future<License> call(User user) {
    return _repository.getLicense(user);
  }
}
