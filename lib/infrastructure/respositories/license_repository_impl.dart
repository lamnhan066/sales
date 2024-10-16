import 'package:sales/domain/entities/license.dart';
import 'package:sales/domain/entities/license_params.dart';
import 'package:sales/domain/entities/user.dart';
import 'package:sales/domain/repositories/license_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseRepositoryImpl implements LicenseRepository {
  final SharedPreferences _prefs;

  const LicenseRepositoryImpl(this._prefs);

  @override
  Future<License> active(LicenseParams params) async {
    if (params.code == '22880253') {
      final license = ActiveLicense(DateTime.now(), 30);
      await _prefs.setString(_getPrefix(params.user), license.toJson());
      return license;
    }
    return const NoLicense();
  }

  @override
  Future<License> activeTrial(User user) async {
    final license = TrialLicense(DateTime.now());
    await _prefs.setString(_getPrefix(user), license.toJson());
    return license;
  }

  @override
  Future<bool> canActiveTrial(User user) async {
    if (_prefs.containsKey(_getPrefix(user))) {
      return false;
    }
    return true;
  }

  @override
  Future<License> getLicense(User user) async {
    final licensePref = _prefs.getString(_getPrefix(user));
    if (licensePref == null) {
      return const NoLicense();
    }
    return License.fromJson(licensePref);
  }

  String _getPrefix(User user) => 'License.${user.username}';
}
