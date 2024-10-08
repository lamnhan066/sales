import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/ranges.dart';

class GetProductParams with EquatableMixin {
  final int page;
  final int perPage;
  final ProductOrderBy orderBy;
  final String searchText;
  final Ranges<double>? priceRange;
  final int? categoryIdFilter;

  const GetProductParams({
    this.page = 1,
    this.perPage = 10,
    this.orderBy = ProductOrderBy.none,
    this.searchText = '',
    this.priceRange,
    this.categoryIdFilter,
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
      'priceRange': priceRange?.toMap(),
      'categoryIdFilter': categoryIdFilter,
    };
  }

  factory GetProductParams.fromMap(Map<String, dynamic> map) {
    return GetProductParams(
      page: map['page']?.toInt() ?? 0,
      perPage: map['perPage']?.toInt() ?? 0,
      orderBy: ProductOrderBy.values.byName(map['orderBy']),
      searchText: map['searchText'] ?? '',
      priceRange: map['priceRange'] != null ? Ranges<double>.fromMap(map['priceRange']) : null,
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
