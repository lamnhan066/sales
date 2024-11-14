import 'package:equatable/equatable.dart';

class AddDiscountParams with EquatableMixin {
  AddDiscountParams({
    required this.percent,
    required this.maxPrice,
    required this.numberOfDiscounts,
  });

  bool get isUnlimited => maxPrice == 0;

  final int percent;
  final int maxPrice;
  final int numberOfDiscounts;

  @override
  List<Object> get props => [percent, maxPrice, numberOfDiscounts];
}
