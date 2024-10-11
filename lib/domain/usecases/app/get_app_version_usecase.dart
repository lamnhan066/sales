import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/app_version.dart';
import 'package:sales/domain/repositories/app_version_repository.dart';

class GetAppVersionUseCase implements UseCase<AppVersion, NoParams> {
  final AppVersionRepository _repository;

  const GetAppVersionUseCase(this._repository);

  @override
  Future<AppVersion> call(NoParams _) {
    return _repository.getAppVersion();
  }
}
