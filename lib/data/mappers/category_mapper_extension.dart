import 'package:sales/data/models/category_model.dart';
import 'package:sales/domain/entities/category.dart';

extension CategoryModelMapper on CategoryModel {
  Category toDomain() {
    return Category(id: id, name: name, description: description);
  }
}

extension CategoryEntityMapper on Category {
  CategoryModel toData() {
    return CategoryModel(id: id, name: name, description: description);
  }
}
