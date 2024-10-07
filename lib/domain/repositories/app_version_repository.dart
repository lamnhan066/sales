import 'package:sales/domain/entities/app_version.dart';

abstract class AppVersionRepository {
  Future<AppVersion> getAppVersion();
}
