import 'package:sales/domain/entities/product.dart';
import 'package:sales/models/category.dart';

class DataImportResult {
  final List<Category> categories;
  final List<Product> products;

  DataImportResult({
    required this.categories,
    required this.products,
  });
}
