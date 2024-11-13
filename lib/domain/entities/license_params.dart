import 'package:sales/domain/entities/user.dart';

class LicenseParams {

  LicenseParams({
    required this.user,
    required this.code,
  });
  final User user;
  final String code;
}
