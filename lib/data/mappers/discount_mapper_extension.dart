import 'package:sales/data/models/discount_model.dart';
import 'package:sales/domain/entities/discount.dart';

extension DiscountModelMapper on DiscountModel {
  Discount toDomain() {
    return Discount(id: id, orderId: orderId, code: code, percent: percent, maxPrice: maxPrice);
  }
}

extension DiscountEntityMapper on Discount {
  DiscountModel toData() {
    return DiscountModel(id: id, code: code, percent: percent, maxPrice: maxPrice, orderId: orderId);
  }
}
