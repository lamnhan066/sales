import 'package:equatable/equatable.dart';
import 'package:features_tour/features_tour.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/ranges.dart';

class ProductsState with EquatableMixin {
  /// Danh sách sản phẩm.
  final List<Product> products;

  /// Số sản phẩm mỗi trang.
  final int perPage;

  /// Vị trí trang hiện tại.
  final int page;

  /// Tổng số trang.
  final int totalPage;

  /// Sắp xếp sản phẩm theo tiêu chí.
  final ProductOrderBy orderBy;

  /// Tìm kiếm sản phẩm.
  final String searchText;

  /// Khoảng giá của sản phẩm.
  final Ranges<double> priceRange;

  /// Lọc sản phẩm theo Loại hàng.
  final int categoryIdFilter;

  /// Danh sách loại hàng.
  final List<Category> categories;

  final FeaturesTourController tour;

  final bool hasDraft;
  final bool isShownDraftDialog;

  final bool isLoading;
  final String error;

  const ProductsState({
    this.products = const [],
    this.perPage = 10,
    this.page = 1,
    this.totalPage = 0,
    this.orderBy = ProductOrderBy.none,
    this.searchText = '',
    this.priceRange = const Ranges(0, double.infinity),
    this.categoryIdFilter = -1,
    this.categories = const [],
    required this.tour,
    this.hasDraft = false,
    this.isShownDraftDialog = false,
    this.isLoading = false,
    this.error = '',
  });

  ProductsState copyWith({
    List<Product>? products,
    int? perPage,
    int? page,
    int? totalPage,
    ProductOrderBy? orderBy,
    String? searchText,
    Ranges<double>? priceRange,
    int? categoryIdFilter,
    List<Category>? categories,
    FeaturesTourController? tour,
    bool? hasDraft,
    bool? isShownDraftDialog,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      orderBy: orderBy ?? this.orderBy,
      searchText: searchText ?? this.searchText,
      priceRange: priceRange ?? this.priceRange,
      categoryIdFilter: categoryIdFilter ?? this.categoryIdFilter,
      categories: categories ?? this.categories,
      tour: tour ?? this.tour,
      hasDraft: hasDraft ?? this.hasDraft,
      isShownDraftDialog: isShownDraftDialog ?? this.isShownDraftDialog,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props {
    return [
      products,
      perPage,
      page,
      totalPage,
      orderBy,
      searchText,
      priceRange,
      categoryIdFilter,
      categories,
      tour,
      hasDraft,
      isShownDraftDialog,
      isLoading,
      error,
    ];
  }
}
