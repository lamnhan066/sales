import 'dart:convert';

import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/repositories/data_importer_repository.dart';
import 'package:sales/infrastructure/utils/excel_picker.dart';

class ExcelDataImporterImpl implements DataImporterRepository {
  // TODO: Hiển thị dialog để người dùng có thể tải xuống mẫu hoặc dữ liệu hiện tại
  @override
  Future<DataImportResult?> importData() async {
    final excel = await ExcelPicker.getExcelFile();
    if (excel == null) {
      return null;
    }

    final firstSheet = excel.tables.entries.first.value;
    final products = <Product>[];
    final categories = <Category>[];
    for (int i = 1; i < firstSheet.maxRows; i++) {
      final row = firstSheet.rows.elementAt(i);
      final categoryName = '${row.elementAt(7)?.value}';
      Category category;
      try {
        category = categories.singleWhere((e) => e.name == categoryName);
      } catch (_) {
        category = Category(
          id: categories.length,
          name: categoryName,
          description: '',
        );
        categories.add(category);
      }
      products.add(
        Product(
          id: i,
          sku: '${row.first?.value}',
          name: '${row.elementAt(1)?.value}',
          imagePath: (jsonDecode('${row.elementAt(2)?.value}') as List<dynamic>).cast<String>(),
          importPrice: int.parse('${row.elementAt(3)?.value}'),
          unitSalePrice: int.parse('${row.elementAt(3)?.value}'),
          count: int.parse('${row.elementAt(5)?.value}'),
          description: '${row.elementAt(6)?.value}',
          categoryId: category.id,
          deleted: bool.parse('${row.elementAt(8)?.value}'),
        ),
      );
    }

    return DataImportResult(categories: categories, products: products);
  }
}
