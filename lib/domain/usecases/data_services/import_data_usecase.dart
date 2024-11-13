import 'package:language_helper/language_helper.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';

class ImportDataUseCase implements UseCase<DataImportResult?, NoParams> {

  const ImportDataUseCase(this._importer);
  final DataImporterRepository _importer;

  @override
  Future<DataImportResult?> call(NoParams params) async {
    try {
      return await _importer.importData();
    } catch (e) {
      throw ImportFailure('Đã có lỗi xảy ra khi nhập dữ liệu, vui lòng kiểm tra lại dữ liệu mẫu'.tr);
    }
  }
}
