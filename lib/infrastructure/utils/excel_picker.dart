
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ExcelPicker {
  /// Tải dữ liệu Excel.
  static Future<Excel?> getExcelFile() async {
    try {
      final file = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (file != null && file.files.isNotEmpty) {
        final bytes = file.files.first.bytes!;

        return Excel.decodeBytes(bytes);
      } else {
        return null;
      }
    } on Exception {
      rethrow;
    }
  }
}
