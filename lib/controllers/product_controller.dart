// ignore_for_file: function_lines_of_code, cyclomatic_complexity
import 'dart:async';
import 'dart:io';

import 'package:boxw/boxw.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/app/app_configs.dart';
import 'package:sales/components/circle_close_button.dart';
import 'package:sales/components/common_dialogs.dart';
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

      final isAdded = await _addCategory(context, setState);

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
    final startController =
        TextEditingController(text: _getPriceRangeText(tempRangeValues.start));
    final endController =
        TextEditingController(text: _getPriceRangeText(tempRangeValues.end));
    final result = await boxWDialog(
      context: context,
      title: 'Bộ lọc'.tr,
      content: Column(
        children: [
          Column(
            children: [
              Text('Lọc theo mức giá'.tr),
              Row(
                children: [
                  Expanded(
                    child: BoxWInput(
                      controller: startController,
                      title: 'Từ'.tr,
                      initial: _getPriceRangeText(tempRangeValues.start),
                      validator: (value) {
                        if (value == null) {
                          return 'Không được bỏ trống'.tr;
                        }
                        final n = double.tryParse(value);
                        if (n == null) {
                          return 'Phải là số nguyên'.tr;
                        }

                        return null;
                      },
                      onChanged: (value) {
                        final start = double.tryParse(value);
                        if (start != null) {
                          tempRangeValues =
                              RangeValues(start, tempRangeValues.end);
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      startController.text = _getPriceRangeText(0);
                      tempRangeValues = RangeValues(0, tempRangeValues.end);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: BoxWInput(
                      controller: endController,
                      title: 'Đến'.tr,
                      validator: (value) {
                        if (value == 'Tối đa'.tr) return null;
                        if (value == null) {
                          return 'Không được bỏ trống'.tr;
                        }
                        final n = double.tryParse(value);
                        if (n == null) {
                          return 'Phải là số nguyên'.tr;
                        }

                        return null;
                      },
                      onChanged: (value) {
                        final end = double.tryParse(value);
                        if (end != null) {
                          tempRangeValues =
                              RangeValues(tempRangeValues.start, end);
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      endController.text = _getPriceRangeText(double.infinity);
                      tempRangeValues = RangeValues(
                        tempRangeValues.start,
                        double.infinity,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _getPriceRangeText(double.infinity),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              Text('Lọc theo loại hàng'.tr),
              BoxWDropdown<int?>(
                title: 'Loại hàng'.tr,
                items: categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      ),
                    )
                    .toList()
                  ..insert(
                    0,
                    DropdownMenuItem(child: Text('Tất cả'.tr)),
                  ),
                value: tempCategoryIdFilter,
                onChanged: (int? value) {
                  tempCategoryIdFilter = value;
                },
              ),
            ],
          ),
        ],
      ),
      buttons: (context) {
        return [
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'.tr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Huỷ'.tr),
                ),
              ),
            ],
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
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'.tr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Huỷ'.tr),
                ),
              ),
            ],
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
          child: Form(
            key: form,
            onChanged: validateForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BoxWInput(
                    title: 'Mã sản phẩm'.tr,
                    initial: tempProduct.sku,
                    readOnly: readOnly,
                    onChanged: (value) {
                      tempProduct = tempProduct.copyWith(sku: value);
                    },
                  ),
                  BoxWInput(
                    title: 'Tên sản phẩm'.tr,
                    initial: tempProduct.name,
                    readOnly: readOnly,
                    onChanged: (value) {
                      tempProduct = tempProduct.copyWith(name: value);
                    },
                  ),
                  BoxWInput(
                    title: 'Giá nhập'.tr,
                    initial: tempProduct.importPrice.toString(),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value != null) {
                        final n = int.tryParse(value);
                        if (n == null) {
                          return 'Vui lòng chỉ nhập số'.tr;
                        }
                      }

                      return null;
                    },
                    onChanged: (value) {
                      final importPrice = int.tryParse(value);
                      if (importPrice != null) {
                        tempProduct =
                            tempProduct.copyWith(importPrice: importPrice);
                      }
                    },
                  ),
                  BoxWInput(
                    title: 'Số lượng'.tr,
                    initial: tempProduct.count.toString(),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value != null) {
                        final n = int.tryParse(value);
                        if (n == null) {
                          return 'Vui lòng chỉ nhập số'.tr;
                        }
                      }

                      return null;
                    },
                    onChanged: (value) {
                      final count = int.tryParse(value);
                      if (count != null) {
                        tempProduct = tempProduct.copyWith(count: count);
                      }
                    },
                  ),
                  if (readOnly)
                    BoxWInput(
                      title: 'Loại hàng'.tr,
                      initial: categories
                          .singleWhere((e) => e.id == tempProduct.categoryId)
                          .name,
                      readOnly: true,
                    )
                  else
                    StatefulBuilder(
                      builder: (context, dropdownSetState) {
                        final dropdowItems = categories.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.name),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _infoCategory(
                                          context,
                                          e,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.info_rounded,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final result = await _editCategory(
                                          context,
                                          setState,
                                          e,
                                        );
                                        if (result) {
                                          dropdownSetState(() {});
                                        }

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final result = await _removeCategory(
                                          context,
                                          setState,
                                          e,
                                        );
                                        if (result) {
                                          dropdownSetState(() {});
                                        }
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList();

                        return Row(
                          children: [
                            Expanded(
                              child: BoxWDropdown(
                                title: 'Loại hàng'.tr,
                                items: dropdowItems,
                                value: tempProduct.categoryId,
                                selectedItemBuilder: (_) {
                                  return categories
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Text(e.name),
                                        ),
                                      )
                                      .toList();
                                },
                                onChanged: (int? value) {
                                  dropdownSetState(() {
                                    tempProduct =
                                        tempProduct.copyWith(categoryId: value);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: readOnly
                                  ? null
                                  : () {
                                      _addCategory(context, setState);
                                    },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        );
                      },
                    ),
                  StatefulBuilder(
                    builder: (context, listViewSetState) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              height:
                                  tempProduct.imagePath.isEmpty ? null : 300,
                              width: double.infinity,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      BoxWConfig.radius,
                                    ),
                                  ),
                                  label: Text('Hình ảnh'.tr),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: tempProduct.imagePath.isEmpty
                                      ? Text(
                                          'Chưa có hình ảnh'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                        )
                                      : ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(
                                            dragDevices: {
                                              ...PointerDeviceKind.values,
                                            },
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                tempProduct.imagePath.length,
                                            itemBuilder: (context, index) {
                                              final source = tempProduct
                                                  .imagePath
                                                  .elementAt(index);

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // TODO: Mở trình xem ảnh khi nhấn vào ảnh
                                                  },
                                                  child: readOnly
                                                      ? _ResolveImage(
                                                          source: source,
                                                        )
                                                      : Stack(
                                                          children: [
                                                            _ResolveImage(
                                                              source: source,
                                                            ),
                                                            Positioned.fill(
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    CircleCloseButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _removeImage(
                                                                      context,
                                                                      tempProduct
                                                                          .imagePath,
                                                                      index,
                                                                      validateForm,
                                                                    );
                                                                    listViewSetState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          if (!readOnly)
                            IconButton(
                              onPressed: () async {
                                await _addImage(
                                  context,
                                  tempProduct.imagePath,
                                  validateForm,
                                );
                                listViewSetState(() {});
                              },
                              icon: const Icon(Icons.add),
                            ),
                        ],
                      );
                    },
                  ),
                  BoxWInput(
                    title: 'Mô tả'.tr,
                    initial: tempProduct.description,
                    readOnly: readOnly,
                    onChanged: (value) {
                      tempProduct = tempProduct.copyWith(description: value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        buttons: (context) {
          return [
            Buttons(
              axis: Axis.horizontal,
              buttons: [
                StreamBuilder<bool>(
                  stream: formValidator.stream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: FilledButton(
                        onPressed: !snapshot.hasData || snapshot.data != true
                            ? null
                            : () {
                                Navigator.pop(context, true);
                              },
                        child: Text('OK'.tr),
                      ),
                    );
                  },
                ),
                if (!readOnly)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Huỷ'.tr),
                    ),
                  ),
              ],
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

  String _getPriceRangeText(double price) {
    if (price == double.infinity) {
      return 'Tối đa'.tr;
    }

    return '${price.toInt()}';
  }

  Future<void> _infoCategory(
    BuildContext context,
    Category category,
  ) async {
    await _categoryDialog(
      context,
      'Chi Tiết Loại Hàng'.tr,
      category,
      true,
    );
  }

  Future<bool> _addCategory(
    BuildContext context,
    SetState setState,
  ) async {
    final Category tempCategory = Category(
      id: await _database.generateCategoryId(),
      name: '',
      description: '',
    );

    if (context.mounted) {
      final category = await _categoryDialog(
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
  Future<bool> _editCategory(
    BuildContext context,
    SetState setState,
    Category category,
  ) async {
    final c = await _categoryDialog(
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

  Future<bool> _removeCategory(
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

  Future<Category?> _categoryDialog(
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
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'.tr),
                ),
              ),
              if (!readOnly)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Huỷ'.tr),
                  ),
                ),
            ],
          ),
        ];
      },
    );

    if (result ?? false) {
      return tempCategory;
    }

    return null;
  }

  Future<void> _removeImage(
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

  Future<void> _addImage(
    BuildContext context,
    List<String> imagePath,
    VoidCallback validateForm,
  ) async {
    String path = '';
    final pathStreamController = StreamController<String>();
    final textController = TextEditingController();
    final isAccepted = await boxWDialog(
      context: context,
      title: 'Thêm Ảnh'.tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vui lòng chọn ảnh từ đường dẫn\ntừ máy hoặc internet'.tr,
            textAlign: TextAlign.center,
          ),
          BoxWInput(
            controller: textController,
            title: 'Đường dẫn'.tr,
            maxLines: 10,
            onChanged: (value) {
              path = value;
              pathStreamController.add(value);
            },
          ),
          TextButton(
            onPressed: () async {
              final picked = await FilePicker.platform.pickFiles(
                dialogTitle: 'Chọn ảnh',
                type: FileType.image,
              );

              if (picked != null && picked.count > 0) {
                path = picked.files.first.path!;
                pathStreamController.add(path);
                textController.text = path;
              }
            },
            child: Text('Chọn ảnh từ máy'.tr),
          ),
        ],
      ),
      buttons: (ctx) {
        return [
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              StreamBuilder<String>(
                stream: pathStreamController.stream,
                builder: (_, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: FilledButton(
                      onPressed: !snapshot.hasData || snapshot.data == ''
                          ? null
                          : () {
                              Navigator.pop(ctx, true);
                            },
                      child: Text('Thêm'.tr),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Huỷ'.tr),
                ),
              ),
            ],
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

/// Kiểm tra `source` là URL hay Path để trả về ảnh.
class _ResolveImage extends StatelessWidget {
  const _ResolveImage({required this.source, super.key});

  final String source;

  @override
  Widget build(BuildContext context) {
    return source.startsWith('http')
        ? Image.network(source)
        : Image.file(File(source));
  }
}
