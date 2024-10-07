import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';
import 'package:sales/infrastucture/utils/app_version_helper.dart';

class AppVersionRepositoryImpl implements AppVersionRepository {
  @override
  Future<AppVersion> getAppVersion() {
    return AppVersionHelper.getVersion();
  }
}
