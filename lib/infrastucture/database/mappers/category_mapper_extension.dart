import 'package:sales/domain/entities/category.dart';
import 'package:sales/infrastucture/database/models/category_model.dart';

extension CategoryModelMapper on CategoryModel {
  Category toCategory() {
    return Category(id: id, name: name, description: description);
  }
}

extension CategoryEntityMapper on Category {
  CategoryModel toCategoryModel() {
    return CategoryModel(id: id, name: name, description: description);
  }
}
