// presentation/views/products_view.dart
import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart' hide DataTable, DataRow, DataColumn, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/core/errors/failure.dart';
import 'package:sales/domain/entities/data_import_result.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/domain/entities/product_order_by.dart';
import 'package:sales/presentation/riverpod/notifiers/products_provider.dart';
import 'package:sales/presentation/riverpod/states/products_state.dart';
import 'package:sales/presentation/widgets/category_dialog.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';
import 'package:sales/presentation/widgets/page_chooser_dialog.dart';
import 'package:sales/presentation/widgets/product_dialog.dart';
import 'package:sales/presentation/widgets/product_filter_dialog.dart';

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key, this.chooseProduct = false});

  final bool chooseProduct;

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  final searchTextController = TextEditingController(text: '');
  final searchTextFocus = FocusNode();
  bool lastSearchFocusState = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    lastSearchFocusState = false;
    searchTextFocus.addListener(searchFocusListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    searchTextFocus.removeListener(searchFocusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsProvider);
    final productNotifier = ref.read(productsProvider.notifier);

    searchTextController.text = productState.searchText;
    if (lastSearchFocusState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchTextFocus.requestFocus();
      });
    }

    if (productState.isLoading) {
      return const SizedBox.shrink();
    }

    if (productState.error.isNotEmpty) {
      return Center(child: Text('Error: ${productState.error}'));
    }

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, productState, productNotifier),
          _buildDataTable(context, productState, productNotifier),
          _buildPaginationControls(context, productState, productNotifier),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ProductsState state, ProductsNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: AppConfigs.toolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton(
              onPressed: () => addProduct(),
              child: const Icon(Icons.add),
            ),
            Row(
              children: [
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _loadDataFromExcel(context),
                  icon: const Icon(Icons.upload_rounded),
                ),
                SizedBox(
                  width: 200,
                  child: BoxWInput(
                    controller: searchTextController,
                    focusNode: searchTextFocus,
                    hintText: 'Tìm Kiếm'.tr,
                    hintStyle: const TextStyle(color: Colors.grey),
                    onChanged: (value) {
                      startSearchAfterDelay(notifier, value);
                    },
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => showFilterDialog(),
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => showSortDialog(),
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, ProductsState state, ProductsNotifier notifier) {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          dataRowMinHeight: 68,
          dataRowMaxHeight: 68,
          columnSpacing: 30,
          horizontalMargin: 10,
          columnWidthBuilder: (index) {
            if (index == 2) {
              return const IntrinsicColumnWidth(flex: 1);
            }
            return null;
          },
          columns: _buildDataColumns(context),
          rows: _buildDataRows(context, state, notifier),
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns(BuildContext context) {
    return [
      _headerTextColumn('STT'.tr),
      _headerTextColumn('ID'.tr),
      _headerTextColumn('Tên'.tr),
      _headerTextColumn('Giá nhập'.tr, numeric: true),
      _headerTextColumn('Giá bán'.tr, numeric: true),
      _headerTextColumn('Loại hàng'.tr),
      _headerTextColumn('Số lượng'.tr, numeric: true),
      _headerTextColumn('Hành động'.tr),
    ];
  }

  DataColumn _headerTextColumn(String text, {bool numeric = false}) {
    return DataColumn(
      numeric: numeric,
      headingRowAlignment: MainAxisAlignment.center,
      label: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<DataRow> _buildDataRows(BuildContext context, ProductsState state, ProductsNotifier notifier) {
    return state.products.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      final category = state.categories.firstWhere((c) => c.id == product.categoryId);

      return DataRow(
        cells: [
          DataCell(Center(child: Text('${(state.page - 1) * state.perPage + index + 1}'))),
          DataCell(Center(child: Text(product.sku))),
          DataCell(Center(child: Text(product.name))),
          // TODO: Giá nhập nên hiện theo dạng phân cách hàng ngàn bằng dấu phẩy
          DataCell(Text('${product.importPrice}')),
          DataCell(Text('${product.unitSalePrice}')),
          DataCell(Center(child: Text(category.name))),
          DataCell(Text('${product.count}')),
          DataCell(Center(child: _buildActionButtons(product))),
        ],
      );
    }).toList();
  }

  Widget _buildActionButtons(Product product) {
    return widget.chooseProduct
        ? IconButton(
            onPressed: () {
              Navigator.pop(context, product);
            },
            icon: const Icon(Icons.check_rounded),
          )
        : Row(
            children: [
              IconButton(
                onPressed: () => viewProduct(product),
                icon: const Icon(Icons.info_rounded),
              ),
              IconButton(
                onPressed: () => updateProduct(product),
                icon: const Icon(Icons.edit_rounded),
              ),
              IconButton(
                onPressed: () => copyProduct(product),
                icon: const Icon(Icons.copy_rounded),
              ),
              IconButton(
                onPressed: () => removeProduct(product),
                icon: const Icon(Icons.close_rounded, color: Colors.red),
              ),
            ],
          );
  }

  Widget _buildPaginationControls(BuildContext context, ProductsState state, ProductsNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: state.page == 1 ? null : () => notifier.goToPreviousPage(),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          TextButton(
            onPressed: state.totalPage <= 1 ? null : () => goToPage(),
            child: Text('${state.page}/${state.totalPage}'),
          ),
          IconButton(
            onPressed: state.page == state.totalPage ? null : () => notifier.goToNextPage(),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  void searchFocusListener() {
    lastSearchFocusState = searchTextFocus.hasFocus;
  }

  void startSearchAfterDelay(ProductsNotifier notifier, String value) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), () {
      notifier.updateSearchText(value);
    });
  }

  /// Thêm sản phẩm.
  Future<void> addProduct() async {
    final state = ref.watch(productsProvider);
    final notifier = ref.read(productsProvider.notifier);

    if (state.categories.isEmpty) {
      final isAccepted = await boxWConfirm(
        context: context,
        title: 'Thông báo'.tr,
        content: 'Bạn cần có it nhất một loại hàng để có thể thêm sản phẩm.\n\n'
                'Bạn có muốn thêm loại hàng không?'
            .tr,
        confirmText: 'Đồng ý'.tr,
        cancelText: 'Huỷ'.tr,
      );

      if (!isAccepted || !context.mounted) return;

      final nextCategoryId = await notifier.getNextCategoryId();
      if (!mounted) return;

      final category = await addCategoryDialog(context, nextCategoryId);

      if (category != null) {
        await notifier.addCategory(category);
      } else {
        return;
      }
    }

    if (!mounted) return;

    final product = await addProductDialog(
      context: context,
      notifier: notifier,
      categories: state.categories,
    );

    if (product != null) {
      await notifier.addProduct(product);
    }
  }

  /// Xoá sản phẩm.
  Future<void> removeProduct(Product product) async {
    final notifier = ref.read(productsProvider.notifier);
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá sản phẩm @{name} không?'.trP({
        'name': product.name,
      }),
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await notifier.removeProduct(product);
    }
  }

  /// Chỉnh sửa sản phẩm
  Future<void> updateProduct(Product product) async {
    final state = ref.watch(productsProvider);
    final notifier = ref.read(productsProvider.notifier);

    final productResult = await updateProductDialog(
      context: context,
      notifier: notifier,
      categories: state.categories,
      product: product,
    );

    if (productResult != null) {
      await notifier.updateProduct(productResult);
    }
  }

  /// Hiển thị chi tiết sản phẩm.
  Future<void> viewProduct(Product product) async {
    final state = ref.watch(productsProvider);
    final notifier = ref.read(productsProvider.notifier);
    await viewProductDialog(
      context: context,
      notifier: notifier,
      categories: state.categories,
      product: product,
    );
  }

  /// Sao chép sản phẩm.
  Future<void> copyProduct(Product product) async {
    final state = ref.watch(productsProvider);
    final notifier = ref.read(productsProvider.notifier);
    final productResult = await copyProductDialog(
      context: context,
      notifier: notifier,
      categories: state.categories,
      product: product,
    );

    if (productResult != null) {
      await notifier.addProduct(productResult);
    }
  }

  /// Callback khi có sự thay đổi về lọc sản phẩm.
  Future<void> showFilterDialog() async {
    final notifier = ref.read(productsProvider.notifier);
    final state = ref.watch(productsProvider);

    var tempPriceRange = state.priceRange;
    var tempCategoryIdFilter = state.categoryIdFilter;
    final result = await boxWDialog(
      context: context,
      title: 'Bộ lọc'.tr,
      content: ProductFilterDialog(
        initialPriceRange: tempPriceRange,
        intialCategoryId: tempCategoryIdFilter,
        categories: state.categories,
        onPriceRangeChanged: (values) {
          tempPriceRange = values;
        },
        onCategoryIdChanged: (id) {
          if (id == null) {
            tempCategoryIdFilter = -1;
          } else {
            tempCategoryIdFilter = id;
          }
        },
      ),
      buttons: (context) {
        return [
          confirmCancelButtons(
            context: context,
            confirmText: 'OK'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    // Chỉ tải lại dữ liệu khi có sự thay đổi.
    if (result == true && (state.priceRange != tempPriceRange || state.categoryIdFilter != tempCategoryIdFilter)) {
      notifier.updateFilters(priceRange: tempPriceRange, categoryIdFilter: tempCategoryIdFilter);
    }
  }

  /// Callback khi có sự thay đổi về sắp xếp.
  Future<void> showSortDialog() async {
    final state = ref.watch(productsProvider);
    final notifier = ref.read(productsProvider.notifier);
    var tempOrderBy = state.orderBy;
    final result = await boxWDialog(
      context: context,
      title: 'Sắp xếp'.tr,
      content: Column(
        children: [
          StatefulBuilder(
            builder: (_, setState) {
              return Column(
                children: [
                  for (final o in ProductOrderBy.values)
                    RadioListTile(
                      value: o,
                      groupValue: tempOrderBy,
                      title: Text(_getOrderByName(o)),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          tempOrderBy = value;
                        });
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
      buttons: (context) {
        return [
          confirmCancelButtons(
            context: context,
            confirmText: 'OK'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    // Chỉ tải lại dữ liệu khi có sự thay đổi.
    if (result == true && tempOrderBy != state.orderBy) {
      notifier.updateOrderBy(tempOrderBy);
    }
  }

  Future<void> _loadDataFromExcel(BuildContext context) async {
    final notifier = ref.read(productsProvider.notifier);

    DataImportResult? data;
    try {
      data = await notifier.importData();
    } on ImportFailure catch (e) {
      if (!context.mounted) return;

      await boxWAlert(context: context, title: 'Nhập Excel'.tr, content: e.message);

      return;
    }

    if (!context.mounted) return;

    if (data == null) {
      await boxWAlert(
        context: context,
        title: 'Nhập Excel'.tr,
        content: 'Bạn chưa chọn tệp hoặc tệp chưa được hỗ trợ'.tr,
      );

      return;
    }

    if (data.products.isEmpty) {
      await boxWAlert(
        context: context,
        title: 'Nhập Excel'.tr,
        content: 'Dữ liệu bạn đang chọn trống!'.tr,
        buttonText: 'Ok'.tr,
      );
    } else {
      final confirm = await boxWConfirm(
        context: context,
        title: 'Nhập Excel'.tr,
        content: 'Có @{count} sản phẩm trong dữ liệu cần nhập. '
                'Dữ liệu mới sẽ thay thế dữ liệu cũ và không thể hoàn tác.\n\n'
                'Bạn có muốn tiếp tục không?'
            .tr
            .trP({'count': data.products.length}),
        confirmText: 'Đồng ý'.tr,
        cancelText: 'Huỷ'.tr,
      );

      if (confirm) {
        await notifier.replaceDatabase(data);
      }
    }
  }

  Future<void> goToPage() async {
    final state = ref.watch(productsProvider);

    final newPage = await pageChooser(context: context, page: state.page, totalPage: state.totalPage);

    if (newPage != null) {
      await ref.read(productsProvider.notifier).goToPage(newPage);
    }
  }

  Future<bool?> confirmAddCategory(BuildContext context) async {
    return await boxWConfirm(
      context: context,
      title: 'Thông báo'.tr,
      content: 'Bạn cần có it nhất một loại hàng để có thể thêm sản phẩm.\n\n'
              'Bạn có muốn thêm loại hàng không?'
          .tr,
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );
  }

  String _getOrderByName(ProductOrderBy orderBy) {
    return switch (orderBy) {
      ProductOrderBy.none => 'Không'.tr,
      ProductOrderBy.nameAsc => 'Tên tăng dần'.tr,
      ProductOrderBy.nameDesc => 'Tên giảm dần'.tr,
      ProductOrderBy.importPriceAsc => 'Giá tăng dần'.tr,
      ProductOrderBy.importPriceDesc => 'Giá giảm dần'.tr,
      ProductOrderBy.countAsc => 'Số lượng tăng đần'.tr,
      ProductOrderBy.countDesc => 'Số lượng giảm đần'.tr,
    };
  }

  Widget _buildCancelButton(BuildContext context) {
    return !widget.chooseProduct
        ? const SizedBox.shrink()
        : FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Trở về'.tr),
          );
  }
}
