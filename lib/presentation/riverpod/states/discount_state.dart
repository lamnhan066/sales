import 'package:equatable/equatable.dart';
import 'package:features_tour/features_tour.dart';
import 'package:sales/domain/entities/discount.dart';

class DiscountState with EquatableMixin {
  DiscountState({
    required this.tour,
    this.perPage = 10,
    this.page = 1,
    this.totalPage = 0,
    this.discounts = const [],
    this.isLoading = false,
    this.error = '',
  });

  final FeaturesTourController tour;
  final List<Discount> discounts;
  final bool isLoading;
  final String error;
  final int perPage;
  final int page;
  final int totalPage;

  DiscountState copyWith({
    FeaturesTourController? tour,
    List<Discount>? discounts,
    bool? isLoading,
    String? error,
    int? perPage,
    int? page,
    int? totalPage,
  }) {
    return DiscountState(
      tour: tour ?? this.tour,
      discounts: discounts ?? this.discounts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  @override
  List<Object> get props {
    return [
      tour,
      discounts,
      isLoading,
      error,
      perPage,
      page,
      totalPage,
    ];
  }
}
