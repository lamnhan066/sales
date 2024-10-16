import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/license_params.dart';
import 'package:sales/domain/entities/user.dart';

abstract class LicenseRepository {
  Future<License> getLicense(User user);
  Future<License> active(LicenseParams params);
  Future<bool> canActiveTrial(User user);
  Future<License> activeTrial(User user);
}
