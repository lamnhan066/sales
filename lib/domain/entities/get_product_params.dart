import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/ranges.dart';

class GetProductParams with EquatableMixin {
  final int page;
  final int perPage;
  final ProductOrderBy orderBy;
  final String searchText;
  final Ranges<double> priceRange;

  /// Lọc theo loại hàng. Nếu giá trị này là -1 thì không lọc theo loại hàng.
  final int categoryIdFilter;

  bool get isUseCategoryFilter => categoryIdFilter != -1;
  bool get isUsePriceRangeFilter => !priceRange.isAllPrices;

  const GetProductParams({
    this.page = 1,
    this.perPage = 10,
    this.orderBy = ProductOrderBy.none,
    this.searchText = '',
    this.priceRange = const Ranges(0, double.infinity),
    this.categoryIdFilter = -1,
  });

  GetProductParams copyWith({
    int? page,
    int? perPage,
    ProductOrderBy? orderBy,
    String? searchText,
    Ranges<double>? priceRange,
    int? categoryIdFilter,
  }) {
    return GetProductParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      orderBy: orderBy ?? this.orderBy,
      searchText: searchText ?? this.searchText,
      priceRange: priceRange ?? this.priceRange,
      categoryIdFilter: categoryIdFilter ?? this.categoryIdFilter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'perPage': perPage,
      'orderBy': orderBy.name,
      'searchText': searchText,
      'priceRange': priceRange.toMap(),
      'categoryIdFilter': categoryIdFilter,
    };
  }

  factory GetProductParams.fromMap(Map<String, dynamic> map) {
    return GetProductParams(
      page: map['page']?.toInt() ?? 0,
      perPage: map['perPage']?.toInt() ?? 0,
      orderBy: ProductOrderBy.values.byName(map['orderBy'].trim()),
      searchText: map['searchText'] ?? '',
      priceRange: Ranges<double>.fromMap(map['priceRange']),
      categoryIdFilter: map['categoryIdFilter']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetProductParams.fromJson(String source) => GetProductParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetProductParams(page: $page, perPage: $perPage, orderBy: $orderBy, searchText: $searchText, priceRange: $priceRange, categoryIdFilter: $categoryIdFilter)';
  }

  @override
  List<Object?> get props {
    return [
      page,
      perPage,
      orderBy,
      searchText,
      priceRange,
      categoryIdFilter,
    ];
  }
}
