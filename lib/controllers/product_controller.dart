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
    final result = await boxWDialog(
      context: context,
      title: 'Chọn trang'.tr,
      content: BoxWInput(
        initial: '$tempPage',
        keyboardType: TextInputType.number,
        validator: (p) {
          if (p == null) return 'Bạn cần nhập số trang'.tr;
          final n = int.tryParse(p);
          if (n == null) {
            return 'Số trang phải là số nguyên'.tr;
          }
          if (n < 1) return 'Số trang phải lớn hơn hoặc bằng 1';
          if (n > totalPage) {
            return 'Số trang phải nhỏ hơn hoặc bằng $totalPage';
          }
          return null;
        },
        onChanged: (value) {
          final p = int.tryParse(value);
          if (p != null) {
            tempPage = p;
          }
        },
      ),
      buttons: (context) {
        // TODO: Ẩn button khi validation ở input không trả về null.
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

    if (result == true && tempPage != page) {
      page = tempPage;
      _changePage(setState, page);
    }
  }

  void loadDataFromExcel(BuildContext context, Function setState) async {
    final data = await Database.loadDataFromExcel();
    if (!context.mounted) return;

    final tempCategories = data.$1;
    final tempProducts = data.$2;

    if (tempProducts.isEmpty) {
      boxWAlert(
        context: context,
        title: 'Nhập dữ liệu'.tr,
        content: 'Dữ liệu bạn đang chọn trống!'.tr,
        buttonText: 'Ok'.tr,
      );
    } else {
      final confirm = await boxWConfirm(
        context: context,
        title: 'Nhập dữ liệu'.tr,
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

        categories.addAll(tempCategories);
        database
            .getProducts(
          page: page,
          perpage: perpage,
          searchText: searchText,
          orderBy: orderBy,
          rangeValues: rangeValues,
        )
            .then((values) {
          setState(() {
            _updatePagesCountAndList(values.$1, values.$2);
          });
        });
      }
    }
  }

  void addProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  ) async {
    final product = await _addProductDialog(context);

    if (product != null) {
      database.addProduct(product);
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
        rangeValues: rangeValues,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
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
      content: 'Bạn có chắc muốn xoá sản phẩm ${p.name} không?'.tr,
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

    if (result == true) {
      await database.removeProduct(p);
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
        rangeValues: rangeValues,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
    }
  }

  void editProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _editProductDialog(context, p);

    if (product != null) {
      database.updateProduct(product);
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
        rangeValues: rangeValues,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
    }
  }

  void infoProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    await _infoProductDialog(context, p);
  }

  void copyProduct(
    BuildContext context,
    void Function(VoidCallback fn) setState,
    Product p,
  ) async {
    final product = await _copyProductDialog(context, p);

    if (product != null) {
      database.addProduct(product);
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
        rangeValues: rangeValues,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
    }
  }

  Future<void> onSearchChanged(Function setState, String text) async {
    searchText = text;
    final p = await database.getProducts(perpage: perpage, searchText: text);
    setState(() {
      _updatePagesCountAndList(p.$1, p.$2);
    });
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

    if (result == true && rangeValues != tempRangeValues) {
      rangeValues = tempRangeValues;
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
        rangeValues: rangeValues,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
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
      database
          .getProducts(
        page: page,
        perpage: perpage,
        searchText: searchText,
        orderBy: orderBy,
      )
          .then((values) {
        setState(() {
          _updatePagesCountAndList(values.$1, values.$2);
        });
      });
    }
  }

  Future<Product?> _infoProductDialog(BuildContext context, Product product) {
    return _productDialog(
      context: context,
      title: 'Thêm Sản Phẩm'.tr,
      product: product,
      generateIdSku: true,
      readOnly: true,
    );
  }

  Future<Product?> _addProductDialog(BuildContext context) {
    return _productDialog(
      context: context,
      title: 'Thêm Sản Phẩm'.tr,
      product: null,
      generateIdSku: true,
    );
  }

  Future<Product?> _editProductDialog(BuildContext context, Product product) {
    return _productDialog(
      context: context,
      title: 'Sửa Sản Phẩm'.tr,
      product: product,
      generateIdSku: false,
    );
  }

  Future<Product?> _copyProductDialog(BuildContext context, Product product) {
    return _productDialog(
      context: context,
      title: 'Chép Sản Phẩm'.tr,
      product: product,
      generateIdSku: true,
    );
  }

  // TODO: Thêm phần hiển thị hình ảnh và có thêm hình ảnh
  Future<Product?> _productDialog({
    required BuildContext context,
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

    if (context.mounted) {
      final result = await boxWDialog(
        context: context,
        title: title,
        content: SingleChildScrollView(
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
                title: 'Mô tả',
                initial: tempProduct.description,
                readOnly: readOnly,
                onChanged: (value) {
                  tempProduct = tempProduct.copyWith(description: value);
                },
              ),
              BoxWInput(
                title: 'Giá nhập',
                initial: tempProduct.importPrice.toString(),
                readOnly: readOnly,
                validator: (value) {
                  if (value != null) {
                    final n = int.tryParse(value);
                    if (n == null) {
                      return 'Vui lòng chỉ nhập số'.tr;
                    }
                    return null;
                  }
                  return null;
                },
                onChanged: (value) {
                  final importPrice = int.tryParse(value);
                  if (importPrice != null) {
                    tempProduct =
                        tempProduct.copyWith(importPrice: importPrice);
                  } else {
                    // TODO: Báo lỗi khi không thể parse giá
                  }
                },
              ),
              BoxWInput(
                title: 'Số lượng',
                initial: tempProduct.count.toString(),
                readOnly: readOnly,
                validator: (value) {
                  if (value != null) {
                    final n = int.tryParse(value);
                    if (n == null) {
                      return 'Vui lòng chỉ nhập số'.tr;
                    }
                    return null;
                  }
                  return null;
                },
                onChanged: (value) {
                  final count = int.tryParse(value);
                  if (count != null) {
                    tempProduct = tempProduct.copyWith(count: count);
                  } else {
                    // TODO: Báo lỗi khi không thể parse số lượng
                  }
                },
              ),
              BoxWDropdown(
                title: 'Loại'.tr,
                items: categories
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                value: tempProduct.categoryId,
                onChanged: readOnly
                    ? null
                    : (int? value) {
                        tempProduct = tempProduct.copyWith(categoryId: value);
                      },
              ),
            ],
          ),
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

      if (result == true) {
        return tempProduct;
      }
    }

    return null;
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
    setState(() {
      page = newPage;
    });
    final p = await database.getProducts(
      page: page,
      perpage: perpage,
      searchText: searchText,
      orderBy: orderBy,
      rangeValues: rangeValues,
    );
    setState(() {
      _updatePagesCountAndList(p.$1, p.$2);
    });
  }

  String _getOrderByName(ProductOrderBy orderBy) {
    return switch (orderBy) {
      ProductOrderBy.none => 'Không'.tr,
      ProductOrderBy.nameInc => 'Tên tăng dần'.tr,
      ProductOrderBy.nameDesc => 'Tên giảm dần'.tr,
      ProductOrderBy.importPriceInc => 'Giá tăng dần'.tr,
      ProductOrderBy.importPriceDesc => 'Giá giảm dần'.tr,
      ProductOrderBy.countInc => 'Số lượng tăng đần'.tr,
      ProductOrderBy.countDesc => 'Số lượng giảm đần'.tr,
    };
  }

  String _getPriceRangeText(double price) {
    if (price == double.infinity) {
      return 'Tối đa'.tr;
    }
    return '$price';
  }
}
