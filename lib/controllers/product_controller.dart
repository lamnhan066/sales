import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/product_order_by.dart';
import 'package:sales/services/database/database.dart';

class ProductController {
  final database = getIt<Database>();
  List<Product> products = [];
  int totalProductsCount = 0;
  final int perpage = 10;
  int page = 1;
  ProductOrderBy orderBy = ProductOrderBy.none;
  String searchText = '';
  RangeValues rangeValues = const RangeValues(0, double.infinity);
  List<Category> categories = [];
  int totalPage = 0;

  Future<void> initial(Function setState) async {
    await database.getAllCategories().then((value) {
      categories = value;
    });
    database.getProducts(page: 1).then((value) {
      setState(() {
        _updatePagesCountAndList(value.$1, value.$2);
      });
    });
  }

  void onPagePrevious(Function setState) async {
    if (page > 1) _changePage(setState, page - 1);
  }

  void onPageNext(Function setState) async {
    if (page < totalPage) _changePage(setState, page + 1);
  }

  void onPageChanged(BuildContext context, Function setState) async {
    int tempPage = page;
    final validatorController = StreamController<bool>();
    String? validator(String? p) {
      if (p == null) return 'Bạn cần nhập số trang'.tr;
      final n = int.tryParse(p);
      if (n == null) return 'Số trang phải là số nguyên'.tr;
      if (n < 1) return 'Số trang phải >= 1'.tr;
      if (n > totalPage) {
        return 'Số trang phải <= @{totalPage}'.trP({'totalPage': totalPage});
      }
      tempPage = n;
      return null;
    }

    final result = await boxWDialog(
      context: context,
      title: 'Chọn trang'.tr,
      content: BoxWInput(
        initial: '$tempPage',
        keyboardType: TextInputType.number,
        validator: (p) {
          final validate = validator(p);
          if (validate == null) {
            validatorController.add(true);
          } else {
            validatorController.add(false);
          }
          return validate;
        },
      ),
      buttons: (context) {
        return [
          Buttons(
            axis: Axis.horizontal,
            buttons: [
              StreamBuilder<bool>(
                stream: validatorController.stream,
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

    if (result == true && tempPage != page) {
      page = tempPage;
      _changePage(setState, page);
    }
  }

  void loadDataFromExcel(BuildContext context, Function setState) async {
    final data = await Database.loadDataFromExcel();
    if (!context.mounted) return;

    if (data == null) {
      boxWAlert(
        context: context,
        title: 'Nhập Excel',
        content: 'Bạn chưa chọn tệp hoặc tệp chưa được hỗ trợ'.tr,
      );
      return;
    }

    final tempCategories = data.$1;
    final tempProducts = data.$2;

    if (tempProducts.isEmpty) {
      boxWAlert(
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
        await database.clear();

        await database.saveAllCategories(tempCategories);
        await database.saveAllProducts(tempProducts);

        _updateCurrentPage(setState);
      }
    }
  }

  void addProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    if (categories.isEmpty) {
      if (await boxWConfirm(
            context: context,
            title: 'Thông báo',
            content:
                'Bạn cần có it nhất một loại hàng để có thể thêm sản phẩm.\n\n'
                        'Bạn có muốn thêm loại hàng không?'
                    .tr,
            confirmText: 'Đồng ý'.tr,
            cancelText: 'Huỷ'.tr,
          ) &&
          context.mounted) {
        await _addCategory(context, setState);
      }
      return;
    }

    final product = await _addProductDialog(context, setState);

    if (product != null) {
      await database.addProduct(product);
      _updateCurrentPage(setState);
    }
  }

  void removeProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final result = await boxWDialog(
      context: context,
      title: 'Xác nhận'.tr,
      content:
          'Bạn có chắc muốn xoá sản phẩm @{name} không?'.trP({'name': p.name}),
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

    if (result == true) {
      await database.removeProduct(p);
      _updateCurrentPage(setState);
    }
  }

  void editProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _editProductDialog(context, setState, p);

    if (product != null) {
      await database.updateProduct(product);
      _updateCurrentPage(setState);
    }
  }

  void infoProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    await _infoProductDialog(context, setState, p);
  }

  void copyProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _copyProductDialog(context, setState, p);

    if (product != null) {
      await database.addProduct(product);
      _updateCurrentPage(setState);
    }
  }

  Future<void> onSearchChanged(Function setState, String text) async {
    searchText = text;
    _updateCurrentPage(setState);
  }

  void onFilterTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    var tempRangeValues = rangeValues;
    List<double> prices = [
      0,
      1000000,
      3000000,
      5000000,
      10000000,
      20000000,
      50000000,
      100000000,
      double.infinity,
    ];
    final startController =
        TextEditingController(text: _getPriceRangeText(tempRangeValues.start));
    final endController =
        TextEditingController(text: _getPriceRangeText(tempRangeValues.end));
    final result = await boxWDialog(
      context: context,
      title: 'Bộ lọc'.tr,
      content: Column(
        children: [
          StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                Text('Lọc theo mức giá'.tr),
                BoxWInput(
                  controller: startController,
                  title: 'Từ'.tr,
                  initial: _getPriceRangeText(tempRangeValues.start),
                  onChanged: (value) {
                    final start = double.tryParse(value);
                    if (start != null) {
                      tempRangeValues = RangeValues(start, tempRangeValues.end);
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
                Wrap(
                  children: [
                    for (final price in prices)
                      InkWell(
                        onTap: () {
                          startController.text = _getPriceRangeText(price);
                          tempRangeValues =
                              RangeValues(price, tempRangeValues.end);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _getPriceRangeText(price),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
                BoxWInput(
                  controller: endController,
                  title: 'Đến'.tr,
                  onChanged: (value) {
                    final end = double.tryParse(value);
                    if (end != null) {
                      tempRangeValues = RangeValues(tempRangeValues.start, end);
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
                Wrap(
                  children: [
                    for (final price in prices)
                      InkWell(
                        onTap: () {
                          endController.text = _getPriceRangeText(price);
                          tempRangeValues =
                              RangeValues(tempRangeValues.start, price);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _getPriceRangeText(price),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),
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

    if (result == true && rangeValues != tempRangeValues) {
      rangeValues = tempRangeValues;
      _updateCurrentPage(setState);
    }
  }

  void onSortTapped(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    var tempOrderBy = orderBy;
    final result = await boxWDialog(
      context: context,
      title: 'Sắp xếp',
      content: Column(
        children: [
          StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                for (final o in ProductOrderBy.values)
                  RadioListTile(
                    value: o,
                    groupValue: tempOrderBy,
                    title: Text(_getOrderByName(o)),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tempOrderBy = value;
                        });
                      }
                    },
                  ),
              ],
            );
          }),
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
                    child: Text('OK'.tr)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Huỷ'.tr)),
              ),
            ],
          ),
        ];
      },
    );

    if (result == true && tempOrderBy != orderBy) {
      orderBy = tempOrderBy;
      _updateCurrentPage(setState);
    }
  }

  Future<Product?> _infoProductDialog(
    BuildContext context,
    Function setState,
    Product product,
  ) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Thông Tin Sản Phẩm'.tr,
      product: product,
      generateIdSku: true,
      readOnly: true,
    );
  }

  Future<Product?> _addProductDialog(BuildContext context, Function setState) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Thêm Sản Phẩm'.tr,
      product: null,
      generateIdSku: true,
    );
  }

  Future<Product?> _editProductDialog(
      BuildContext context, Function setState, Product product) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Sửa Sản Phẩm'.tr,
      product: product,
      generateIdSku: false,
    );
  }

  Future<Product?> _copyProductDialog(
      BuildContext context, Function setState, Product product) {
    return _productDialog(
      context: context,
      setState: setState,
      title: 'Chép Sản Phẩm'.tr,
      product: product,
      generateIdSku: true,
    );
  }

  // TODO: Thêm phần hiển thị hình ảnh và có thêm hình ảnh
  Future<Product?> _productDialog({
    required BuildContext context,
    required Function setState,
    required String title,
    required Product? product,
    required bool generateIdSku,
    bool readOnly = false,
  }) async {
    Product tempProduct = product ??
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
      final idSku = await database.generateProductIdSku();
      tempProduct = tempProduct.copyWith(id: idSku.$1, sku: idSku.$2);
    }

    final form = GlobalKey<FormState>();
    final formValidator = StreamController<bool>();

    if (context.mounted) {
      final result = await boxWDialog(
        context: context,
        title: title,
        width: MediaQuery.sizeOf(context).width * 3 / 5,
        constrains: BoxConstraints(
          minWidth: 280,
          maxWidth: MediaQuery.sizeOf(context).width * 3 / 5,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 3 / 5,
          ),
          child: Form(
            key: form,
            onChanged: () {
              formValidator.add(form.currentState!.validate());
            },
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
                      builder: (context, localSetState) {
                        return Row(
                          children: [
                            Expanded(
                              child: BoxWDropdown(
                                title: 'Loại hàng'.tr,
                                items: categories
                                    .map((e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(e.name),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _infoCategory(
                                                          context, setState, e);
                                                    },
                                                    icon: const Icon(
                                                        Icons.info_rounded),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await _editCategory(
                                                          context, setState, e);
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await _removeCategory(
                                                          context, setState, e);
                                                      localSetState(() {});
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
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                value: tempProduct.categoryId,
                                selectedItemBuilder: (context) {
                                  return categories
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(e.name),
                                          ))
                                      .toList();
                                },
                                onChanged: (int? value) {
                                  localSetState(() {
                                    tempProduct =
                                        tempProduct.copyWith(categoryId: value);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: readOnly
                                  ? null
                                  : () async {
                                      await _addCategory(context, setState);
                                      localSetState(() {});
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
                    }),
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

      if (result == true) {
        return tempProduct;
      }
    }

    return null;
  }

  void _updateCurrentPage(Function setState) async {
    categories = await database.getAllCategories();
    final (totalPages, products) = await database.getProducts(
      page: page,
      perpage: perpage,
      searchText: searchText,
      orderBy: orderBy,
      rangeValues: rangeValues,
    );
    setState(() {
      _updatePagesCountAndList(totalPages, products);
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

  void _changePage(Function setState, int newPage) async {
    page = newPage;
    _updateCurrentPage(setState);
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
    return '$price';
  }

  Future<void> _infoCategory(
    BuildContext context,
    Function setState,
    Category category,
  ) async {
    await _categoryDialog(
      context,
      'Chi Tiết Loại Hàng'.tr,
      category,
      true,
    );
  }

  Future<void> _addCategory(BuildContext context, Function setState) async {
    Category tempCategory = Category(
      id: await database.generateCategoryId(),
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
        await database.addCategory(category);
        _updateCurrentPage(setState);
      }
    }
  }

  Future<void> _editCategory(
    BuildContext context,
    Function setState,
    Category category,
  ) async {
    if (context.mounted) {
      final c = await _categoryDialog(
        context,
        'Sửa Loại Hàng'.tr,
        category,
      );

      if (c != null) {
        await database.updateCategory(c);
        _updateCurrentPage(setState);
      }
    }
  }

  Future<void> _removeCategory(
    BuildContext context,
    Function setState,
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
      await database.removeCategory(category);
      _updateCurrentPage(setState);
    }
  }

  Future<Category?> _categoryDialog(
    BuildContext context,
    String title,
    Category category, [
    bool readOnly = false,
  ]) async {
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
              category = category.copyWith(name: value);
            },
          ),
          BoxWInput(
            title: 'Mô tả'.tr,
            initial: category.description,
            readOnly: readOnly,
            onChanged: (value) {
              category = category.copyWith(description: value);
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

    if (result == true) {
      return category;
    }

    return null;
  }
}
