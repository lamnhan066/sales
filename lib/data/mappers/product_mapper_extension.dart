import 'package:sales/data/models/product_model.dart';
import 'package:sales/domain/entities/product.dart';

extension ProductModelMapper on ProductModel {
  Product toDomain() {
    return Product(
      id: id,
      sku: sku,
      name: name,
      imagePath: imagePath,
      importPrice: importPrice,
      unitSalePrice: unitSalePrice,
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
      unitSalePrice: unitSalePrice,
      count: count,
      description: description,
      categoryId: categoryId,
    );
  }
}
