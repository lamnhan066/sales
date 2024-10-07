// ignore_for_file: function_lines_of_code, cyclomatic_complexity
import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/components/common_dialogs.dart';
import 'package:sales/components/products/add_image_dialog.dart';
import 'package:sales/components/products/product_category_dialog.dart';
import 'package:sales/components/products/product_form_dialog.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/services/database/database.dart';

/// Controller cho màn hình Products.
class ProductController {
  final _database = getIt<Database>();

  /// Danh sách sản phẩm.
  List<Product> products = [];

  /// Số sản phẩm mỗi trang.
  final int perpage = 10;

  /// Vị trí trang hiện tại.
  int page = 1;

  /// Tổng số trang.
  int totalPage = 0;

  /// Sắp xếp sản phẩm theo tiêu chí.
  ProductOrderBy orderBy = ProductOrderBy.none;

  /// Tìm kiếm sản phẩm.
  String searchText = '';

  /// Khoảng giá của sản phẩm.
  RangeValues rangeValues = const RangeValues(0, double.infinity);

  /// Lọc sản phẩm theo Loại hàng.
  int? categoryIdFilter;

  /// Danh sách loại hàng.
  List<Category> categories = [];

  /// Khởi tạo.
  Future<void> initial(SetState setState) async {
    await _database.getAllCategories().then((value) {
      categories = value;
    });
    await _database.getProducts().then((value) {
      setState(() {
        _updatePagesCountAndList(value.totalCount, value.products);
      });
    });
  }

  /// Callback cho nút trang trước.
  Future<void> onPagePrevious(SetState setState) async {
    if (page <= 1) return;

    await _changePage(setState, page - 1);
  }

  /// Callback cho nút trang kế.
  Future<void> onPageNext(SetState setState) async {
    if (page >= totalPage) return;

    await _changePage(setState, page + 1);
  }

  /// Callback cho việc thay đổi trang.
  Future<void> onPageChanged(BuildContext context, SetState setState) async {
    final newPage =
        await pageChooser(context: context, page: page, totalPage: totalPage);

    if (newPage != null) {
      page = newPage;
      await _changePage(setState, page);
    }
  }

  // TODO: Hiển thị dialog để người dùng có thể tải xuống mẫu hoặc dữ liệu hiện tại
  /// Tải dữ liệu từ Excel.
  Future<void> loadDataFromExcel(
    BuildContext context,
    SetState setState,
  ) async {
    final data = await Database.loadDataFromExcel();
    if (!context.mounted) return;

    if (data == null) {
      await boxWAlert(
        context: context,
        title: 'Nhập Excel',
        content: 'Bạn chưa chọn tệp hoặc tệp chưa được hỗ trợ'.tr,
      );

      return;
    }

    final tempCategories = data.categories;
    final tempProducts = data.products;

    if (tempProducts.isEmpty) {
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
            .trP({'count': tempProducts.length}),
        confirmText: 'Đồng ý'.tr,
        cancelText: 'Huỷ'.tr,
      );

      if (confirm) {
        await _database.clear();

        await _database.saveAllCategories(tempCategories);
        await _database.saveAllProducts(tempProducts);

        await _updateCurrentPage(setState);
      }
    }
  }

  /// Thêm sản phẩm.
  Future<void> addProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    if (categories.isEmpty) {
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

      final isAdded = await addCategory(context, setState);

      if (!isAdded) return;
    }

    if (!context.mounted) return;

    final product = await _addProductDialog(context, setState);

    if (product != null) {
      await _database.addProduct(product);
      await _updateCurrentPage(setState);
    }
  }

  /// Xoá sản phẩm.
  Future<void> removeProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá sản phẩm @{name} không?'.trP({
        'name': p.name,
      }),
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result == true) {
      await _database.removeProduct(p);
      await _updateCurrentPage(setState);
    }
  }

  /// Chỉnh sửa sản phẩm
  Future<void> editProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _editProductDialog(context, setState, p);

    if (product != null) {
      await _database.updateProduct(product);
      await _updateCurrentPage(setState);
    }
  }

  /// Hiển thị chi tiết sản phẩm.
  Future<void> infoProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    await _infoProductDialog(context, setState, p);
  }

  /// Sao chép sản phẩm.
  Future<void> copyProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _copyProductDialog(context, setState, p);

    if (product != null) {
      await _database.addProduct(product);
      await _updateCurrentPage(setState);
    }
  }

  /// Callback khi có thay đổi thông tin tìm kiếm.
  Future<void> onSearchChanged(SetState setState, String text) async {
    // Chỉ tải lại dữ liệu khi có sự thay đổi.
    if (searchText == text) return;

    searchText = text;
    await _updateCurrentPage(setState, resetPage: true);
  }

  /// Callback khi có sự thay đổi về lọc sản phẩm.
  Future<void> onFilterTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    var tempRangeValues = rangeValues;
    var tempCategoryIdFilter = categoryIdFilter;
    final result = await boxWDialog(
      context: context,
      title: 'Bộ lọc'.tr,
      content: ProductFilterDialog(
        initialRangeValues: tempRangeValues,
        categories: categories,
        onRangeValuesChanged: (values) {
          tempRangeValues = values;
        },
        onCategoryIdChanged: (id) {
          tempCategoryIdFilter = id;
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
    if (result == true &&
        (rangeValues != tempRangeValues ||
            categoryIdFilter != tempCategoryIdFilter)) {
      rangeValues = tempRangeValues;
      categoryIdFilter = tempCategoryIdFilter;
      await _updateCurrentPage(setState, resetPage: true);
    }
  }

  /// Callback khi có sự thay đổi về sắp xếp.
  Future<void> onSortTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    var tempOrderBy = orderBy;
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
    if (result == true && tempOrderBy != orderBy) {
      orderBy = tempOrderBy;
      await _updateCurrentPage(setState, resetPage: true);
    }
  }
}

/// Nơi chứa các hàm Private
extension PrivateProductController on ProductController {
  Future<Product?> _infoProductDialog(
    BuildContext context,
    SetState setState,
    Product product,
  ) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Thông Tin Sản Phẩm'.tr,
      product: product,
      generateIdSku: false,
      readOnly: true,
    );
  }

  Future<Product?> _addProductDialog(BuildContext context, SetState setState) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Thêm Sản Phẩm'.tr,
      product: null,
      generateIdSku: true,
    );
  }

  Future<Product?> _editProductDialog(
    BuildContext context,
    SetState setState,
    Product product,
  ) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Sửa Sản Phẩm'.tr,
      product: product,
      generateIdSku: false,
    );
  }

  Future<Product?> _copyProductDialog(
    BuildContext context,
    SetState setState,
    Product product,
  ) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Chép Sản Phẩm'.tr,
      product: product,
      generateIdSku: true,
    );
  }

  Future<Product?> _productDialog({
    required BuildContext context,
    required SetState setState,
    required String title,
    required Product? product,
    required bool generateIdSku,
    bool readOnly = false,
  }) async {
    Product tempProduct =
        product?.copyWith(imagePath: [...product.imagePath]) ??
            Product(
              id: 0,
              sku: '',
              name: '',
              imagePath: [],
              importPrice: 0,
              count: 1,
              description: '',
              categoryId: categories.first.id,
            );
    if (generateIdSku || product == null) {
      final idSku = await _database.generateProductIdSku();
      tempProduct = tempProduct.copyWith(id: idSku.id, sku: idSku.sku);
    }

    final form = GlobalKey<FormState>();
    final formValidator = StreamController<bool>();

    void validateForm() {
      formValidator.add(form.currentState?.validate() ?? false);
    }

    if (readOnly) formValidator.add(true);

    if (context.mounted) {
      final result = await boxWDialog(
        context: context,
        title: title,
        width: MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio,
        constrains: BoxConstraints(
          minWidth: AppConfigs.dialogMinWidth,
          maxWidth:
              MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.sizeOf(context).height * AppConfigs.dialogWidthRatio,
          ),
          child: ProductFormDialog(
            controller: this,
            form: form,
            tempProduct: tempProduct,
            validateForm: validateForm,
            categories: categories,
            readOnly: readOnly,
            onChanged: (product) {
              tempProduct = product;
            },
          ),
        ),
        buttons: (context) {
          return [
            confirmCancelButtons(
              context: context,
              enableConfirmStream: formValidator.stream,
              confirmText: 'OK'.tr,
              cancelText: 'Huỷ'.tr,
              hideCancel: readOnly,
            ),
          ];
        },
      );

      await formValidator.close();

      if (result == true) {
        return tempProduct;
      }
    }

    return null;
  }

  Future<void> _updateCurrentPage(
    SetState setState, {
    bool resetPage = false,
  }) async {
    if (resetPage) page = 1;

    categories = await _database.getAllCategories();
    final products = await _database.getProducts(
      page: page,
      perpage: perpage,
      searchText: searchText,
      orderBy: orderBy,
      rangeValues: rangeValues,
      categoryId: categoryIdFilter,
    );
    setState(() {
      _updatePagesCountAndList(products.totalCount, products.products);
    });
  }

  void _updatePagesCountAndList(int totalProductsCount, List<Product> p) {
    products = p;

    totalPage = (totalProductsCount / perpage).floor();
    // Nếu tồn tại số dư thì số trang được cộng thêm 1 vì tôn tại trang có
    // ít hơn `_perpage` sản phẩm.
    if (totalProductsCount % perpage != 0) {
      totalPage += 1;
    }
  }

  Future<void> _changePage(SetState setState, int newPage) async {
    page = newPage;
    await _updateCurrentPage(setState);
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

  Future<void> infoCategory(
    BuildContext context,
    Category category,
  ) async {
    await categoryDialog(
      context,
      'Chi Tiết Loại Hàng'.tr,
      category,
      true,
    );
  }

  Future<bool> addCategory(
    BuildContext context,
    SetState setState,
  ) async {
    final Category tempCategory = Category(
      id: await _database.generateCategoryId(),
      name: '',
      description: '',
    );

    if (context.mounted) {
      final category = await categoryDialog(
        context,
        'Thêm Loại Hàng'.tr,
        tempCategory,
      );

      if (category != null) {
        await _database.addCategory(category);
        await _updateCurrentPage(setState);

        return true;
      }
    }

    return false;
  }

  /// Cập nhật category. Trả về `true` nếu có sự thay đổi.
  Future<bool> editCategory(
    BuildContext context,
    SetState setState,
    Category category,
  ) async {
    final c = await categoryDialog(
      context,
      'Sửa Loại Hàng'.tr,
      category,
    );

    if (c != null) {
      await _database.updateCategory(c);
      await _updateCurrentPage(setState);

      return true;
    }

    return false;
  }

  Future<bool> removeCategory(
    BuildContext context,
    SetState setState,
    Category category,
  ) async {
    final result = await boxWConfirm(
      context: context,
      title: 'Xác nhận'.tr,
      content: 'Bạn có chắc muốn xoá loại hàng @{name} không?'
          .trP({'name': category.name}),
      confirmText: 'Đồng ý'.tr,
      cancelText: 'Huỷ'.tr,
    );

    if (result) {
      await _database.removeCategory(category);
      await _updateCurrentPage(setState);

      return true;
    }

    return false;
  }

  Future<Category?> categoryDialog(
    BuildContext context,
    String title,
    Category category, [
    bool readOnly = false,
  ]) async {
    Category tempCategory = category;
    final result = await boxWDialog<bool>(
      context: context,
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BoxWInput(
            title: 'Tên'.tr,
            initial: category.name,
            readOnly: readOnly,
            onChanged: (value) {
              tempCategory = category.copyWith(name: value);
            },
          ),
          BoxWInput(
            title: 'Mô tả'.tr,
            initial: category.description,
            readOnly: readOnly,
            onChanged: (value) {
              tempCategory = category.copyWith(description: value);
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
            hideCancel: readOnly,
          ),
        ];
      },
    );

    if (result ?? false) {
      return tempCategory;
    }

    return null;
  }

  Future<void> removeImage(
    BuildContext context,
    List<String> imagePath,
    int index,
    void Function() validateForm,
  ) async {
    final isRemoved = await boxWConfirm(
      context: context,
      title: 'Xoá Ảnh'.tr,
      content: 'Bạn có chắc muốn xoá ảnh này không?'.tr,
      confirmText: 'Có'.tr,
      cancelText: 'Không'.tr,
    );

    if (isRemoved) {
      imagePath.removeAt(index);
      validateForm();
    }
  }

  Future<void> addImage(
    BuildContext context,
    List<String> imagePath,
    VoidCallback validateForm,
  ) async {
    String path = '';
    final pathStreamController = StreamController<bool>();
    final textController = TextEditingController();
    final isAccepted = await boxWDialog(
      context: context,
      title: 'Thêm Ảnh'.tr,
      content: AddImageDialog(
        pathController: textController,
        onChanged: (value) {
          path = value;
          pathStreamController.add(value != '');
          textController.text = path;
        },
      ),
      buttons: (ctx) {
        return [
          confirmCancelButtons(
            context: context,
            enableConfirmStream: pathStreamController.stream,
            confirmText: 'Thêm'.tr,
            cancelText: 'Huỷ'.tr,
          ),
        ];
      },
    );

    await pathStreamController.close();

    if (isAccepted == true && path.isNotEmpty) {
      imagePath.add(path);

      validateForm();
    }
  }
}
