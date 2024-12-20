import 'package:features_tour/features_tour.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/di.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/entities/get_product_params.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/domain/entities/ranges.dart';
import 'package:sales/domain/usecases/app/get_item_per_page_usecase.dart';
import 'package:sales/domain/usecases/categories/add_category_usecase.dart';
import 'package:sales/domain/usecases/categories/get_all_categories.dart';
import 'package:sales/domain/usecases/categories/get_next_category_id_usecase.dart';
import 'package:sales/domain/usecases/categories/remove_category_usecase.dart';
import 'package:sales/domain/usecases/categories/update_category_usecase.dart';
import 'package:sales/domain/usecases/data_services/download_template_usecase.dart';
import 'package:sales/domain/usecases/data_services/import_data_usecase.dart';
import 'package:sales/domain/usecases/data_services/replace_database_usecase.dart';
import 'package:sales/domain/usecases/products/add_product_usecase.dart';
import 'package:sales/domain/usecases/products/get_next_product_id_and_sku_usecase.dart';
import 'package:sales/domain/usecases/products/get_products_usecase.dart';
import 'package:sales/domain/usecases/products/get_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/remove_product_usecase.dart';
import 'package:sales/domain/usecases/products/remove_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/save_temporary_product_usecase.dart';
import 'package:sales/domain/usecases/products/update_product_usecase.dart';
import 'package:sales/presentation/riverpod/states/products_state.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    getAllCategoriesUsecCase: getIt(),
    getProductsUseCase: getIt(),
    addProductUseCase: getIt(),
    removeProductUseCase: getIt(),
    updateProductUseCase: getIt(),
    getNextCategoryIdUseCase: getIt(),
    addCategoryUseCase: getIt(),
    removeCategoryUseCase: getIt(),
    updateCategoryUseCase: getIt(),
    getNextProductIdAndSkuUseCase: getIt(),
    replaceDatabaseUsecase: getIt(),
    importDataUseCase: getIt(),
    getItemPerPageUseCase: getIt(),
    saveTemporaryProductUseCase: getIt(),
    getTemporaryProductUseCase: getIt(),
    removeTemporaryProductUseCase: getIt(),
    downloadTemplateUseCase: getIt(),
  );
});

class ProductsNotifier extends StateNotifier<ProductsState> {

  ProductsNotifier({
    required GetAllCategoriesUsecCase getAllCategoriesUsecCase,
    required GetProductsUseCase getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required RemoveProductUseCase removeProductUseCase,
    required GetNextCategoryIdUseCase getNextCategoryIdUseCase,
    required AddCategoryUseCase addCategoryUseCase,
    required GetNextProductIdAndSkuUseCase getNextProductIdAndSkuUseCase,
    required RemoveCategoryUseCase removeCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required ReplaceDatabaseUsecase replaceDatabaseUsecase,
    required ImportDataUseCase importDataUseCase,
    required GetItemPerPageUseCase getItemPerPageUseCase,
    required SaveTemporaryProductUseCase saveTemporaryProductUseCase,
    required GetTemporaryProductUseCase getTemporaryProductUseCase,
    required RemoveTemporaryProductUseCase removeTemporaryProductUseCase,
    required DownloadTemplateUseCase downloadTemplateUseCase,
  })  : _importDataUseCase = importDataUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _removeCategoryUseCase = removeCategoryUseCase,
        _getNextProductIdAndSkuUseCase = getNextProductIdAndSkuUseCase,
        _removeProductUseCase = removeProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _addProductUseCase = addProductUseCase,
        _getProductsUseCase = getProductsUseCase,
        _getAllCategoriesUseCase = getAllCategoriesUsecCase,
        _addCategoryUseCase = addCategoryUseCase,
        _getNextCategoryIdUseCase = getNextCategoryIdUseCase,
        _replaceDatabaseUsecase = replaceDatabaseUsecase,
        _getItemPerPageUseCase = getItemPerPageUseCase,
        _saveTemporaryProductUseCase = saveTemporaryProductUseCase,
        _getTemporaryProductUseCase = getTemporaryProductUseCase,
        _removeTemporaryProductUseCase = removeTemporaryProductUseCase,
        _downloadTemplateUseCase = downloadTemplateUseCase,
        super(ProductsState(tour: FeaturesTourController('ProductsView')));
  final GetAllCategoriesUsecCase _getAllCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final RemoveProductUseCase _removeProductUseCase;
  final GetNextCategoryIdUseCase _getNextCategoryIdUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final RemoveCategoryUseCase _removeCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final GetNextProductIdAndSkuUseCase _getNextProductIdAndSkuUseCase;
  final ReplaceDatabaseUsecase _replaceDatabaseUsecase;
  final ImportDataUseCase _importDataUseCase;
  final GetItemPerPageUseCase _getItemPerPageUseCase;
  final SaveTemporaryProductUseCase _saveTemporaryProductUseCase;
  final GetTemporaryProductUseCase _getTemporaryProductUseCase;
  final RemoveTemporaryProductUseCase _removeTemporaryProductUseCase;
  final DownloadTemplateUseCase _downloadTemplateUseCase;

  Future<void> loadInitialData() async {
    final perPage = await _getItemPerPageUseCase(NoParams());
    state = state.copyWith(perPage: perPage, isLoading: true);
    var error = '';
    try {
      final categories = await _getAllCategoriesUseCase(NoParams());
      state = state.copyWith(categories: categories);
      await fetchProducts(resetPage: true);
    } on Failure catch (e) {
      error = e.message;
    }
    final draftProduct = await _getTemporaryProductUseCase(NoParams());
    var hasDraft = false;
    if (draftProduct != null) {
      hasDraft = true;
    }
    state = state.copyWith(hasDraft: hasDraft, isLoading: false, error: error);
  }

  Future<void> addProduct(Product product) async {
    try {
      await _addProductUseCase(product);
      await fetchProducts();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _updateProductUseCase(product);
      await fetchProducts();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      await _removeProductUseCase(product);
      await fetchProducts();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _addCategoryUseCase(category);
      await fetchCategories();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  Future<void> removeCategory(Category category) async {
    try {
      await _removeCategoryUseCase(category);
      await fetchCategories();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _updateCategoryUseCase(category);
      await fetchCategories();
    } on Failure catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Callback cho nút trang trước.
  Future<void> goToPreviousPage() async {
    await goToPage(state.page - 1);
  }

  /// Callback cho nút trang kế.
  Future<void> goToNextPage() async {
    await goToPage(state.page + 1);
  }

  /// Thay đổi trang hiện tại.
  Future<void> goToPage(int page) async {
    if (page < 1 || page > state.totalPage) return;
    state = state.copyWith(page: page);
    await fetchProducts();
  }

  Future<({int id, String sku})> getNextProductIdAndSku() async {
    return _getNextProductIdAndSkuUseCase(NoParams());
  }

  Future<int> getNextCategoryId() async {
    return _getNextCategoryIdUseCase(NoParams());
  }

  ///
  Future<void> updateSearchText(String text) async {
    if (state.searchText == text) return;
    state = state.copyWith(searchText: text);
    await fetchProducts(resetPage: true);
  }

  Future<void> updateFilters({
    Ranges<double>? priceRange,
    int? categoryIdFilter,
  }) async {
    state = state.copyWith(
      priceRange: priceRange ?? state.priceRange,
      categoryIdFilter: categoryIdFilter,
    );
    await fetchProducts(resetPage: true);
  }

  Future<void> updateOrderBy(ProductOrderBy orderBy) async {
    if (state.orderBy == orderBy) return;
    state = state.copyWith(orderBy: orderBy);
    await fetchProducts(resetPage: true);
  }

  Future<void> replaceDatabase(DataImportResult data) async {
    await _replaceDatabaseUsecase(data);
    await fetchCategories();
    await fetchProducts(resetPage: true);
  }

  Future<DataImportResult?> importData() async {
    return _importDataUseCase(NoParams());
  }

  Future<void> fetchCategories() async {
    final categories = await _getAllCategoriesUseCase(NoParams());
    state = state.copyWith(categories: categories);
  }

  Future<void> fetchProducts({bool resetPage = false}) async {
    if (resetPage) state = state.copyWith(page: 1);

    try {
      final productsResult = await _getProductsUseCase(GetProductParams(
        page: state.page,
        perPage: state.perPage,
        searchText: state.searchText,
        orderBy: state.orderBy,
        priceRange: state.priceRange,
        categoryIdFilter: state.categoryIdFilter,
      ),);

      state = state.copyWith(
        products: productsResult.items,
        totalPage: (productsResult.totalCount / state.perPage).ceil(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updatePerPage(int itemPerPage) async {
    if (itemPerPage == state.perPage) return;

    state = state.copyWith(perPage: itemPerPage);
    await fetchProducts(resetPage: true);
  }

  Future<Product?> getTemporaryProduct() {
    return _getTemporaryProductUseCase(NoParams());
  }

  Future<void> saveTemporaryProduct(Product product) {
    return _saveTemporaryProductUseCase(product);
  }

  Future<void> removeTemporaryProduct() async {
    await _removeTemporaryProductUseCase(NoParams());
  }

  bool canShowProductDialog() {
    final canShow = state.isShownDraftDialog == false;
    if (!canShow) {
      return false;
    }
    state = state.copyWith(isShownDraftDialog: true);
    return true;
  }

  void closeProductDialog() {
    state = state.copyWith(isShownDraftDialog: false, hasDraft: false);
  }

  Future<void> downloadProductTemplate() async {
    await _downloadTemplateUseCase(NoParams());
  }
}
