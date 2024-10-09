import 'package:sales/domain/entities/product.dart';
import 'package:sales/infrastucture/database/models/product_model.dart';

extension ProductModelMapper on ProductModel {
  Product toDomain() {
    return Product(
      id: id,
      sku: sku,
      name: name,
      imagePath: imagePath,
      importPrice: importPrice,
      count: count,
      description: description,
      categoryId: categoryId,
    );
  }
}

extension ProductEntityMapper on Product {
  ProductModel toData() {
    return ProductModel(
      id: id,
      sku: sku,
      name: name,
      imagePath: imagePath,
      importPrice: importPrice,
      count: count,
      description: description,
      categoryId: categoryId,
    );
  }
}
