import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/product.dart';

class DataImportResult with EquatableMixin {
  final List<Category> categories;
  final List<Product> products;

  DataImportResult({
    required this.categories,
    required this.products,
  });

  @override
  List<Object> get props => [categories, products];
}
