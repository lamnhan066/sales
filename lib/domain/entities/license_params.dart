import 'package:sales/domain/entities/user.dart';

class LicenseParams {
  final User user;
  final String code;

  LicenseParams({
    required this.user,
    required this.code,
  });
}
