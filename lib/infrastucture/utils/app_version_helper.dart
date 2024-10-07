import 'package:package_info_plus/package_info_plus.dart';
import 'package:sales/domain/entities/app_version.dart';

class AppVersionHelper {
  /// Lấy phiên bản ứng dụng.
  static Future<AppVersion> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return AppVersion(version: info.version);
  }
}
