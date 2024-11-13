import 'dart:io';
import 'dart:ui';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/notifiers/products_provider.dart';
import 'package:sales/presentation/widgets/category_dialog.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/image_dialog.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    required this.notifier,
    required this.form,
    required this.categories,
    required this.validateForm,
    required this.tempProduct,
    required this.readOnly,
    required this.onChanged,
    super.key,
  });

  final ProductsNotifier notifier;
  final GlobalKey<FormState> form;
  final List<Category> categories;
  final VoidCallback validateForm;
  final Product tempProduct;
  final bool readOnly;
  final void Function(Product) onChanged;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late Product tempProduct;

  List<DropdownMenuItem<int>> dropdownItems(BuildContext context) {
    return widget.categories.map((e) {
      return DropdownMenuItem<int>(
        value: e.id,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(e.name),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    viewCategoryDialog(context, e);
                  },
                  icon: const Icon(
                    Icons.info_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await updateCategoryDialog(
                      context,
                      widget.notifier,
                      e,
                    );
                    if (result) {
                      setState(() {});
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await removeCategoryDialog(
                      context,
                      widget.notifier,
                      e,
                    );
                    if (result) {
                      setState(() {});
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
  }

  @override
  void initState() {
    tempProduct = widget.tempProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form,
      onChanged: widget.validateForm,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BoxWInput(
              title: 'Mã sản phẩm'.tr,
              initial: widget.tempProduct.sku,
              readOnly: widget.readOnly,
              onChanged: (value) {
                tempProduct = tempProduct.copyWith(sku: value);
                widget.onChanged(tempProduct);
              },
            ),
            BoxWInput(
              title: 'Tên sản phẩm'.tr,
              initial: widget.tempProduct.name,
              readOnly: widget.readOnly,
              onChanged: (value) {
                tempProduct = tempProduct.copyWith(name: value);
                widget.onChanged(tempProduct);
              },
            ),
            BoxWInput(
              title: 'Giá nhập'.tr,
              initial: widget.tempProduct.importPrice.toString(),
              readOnly: widget.readOnly,
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
                  tempProduct = tempProduct.copyWith(importPrice: importPrice);
                  widget.onChanged(tempProduct);
                }
              },
            ),
            BoxWInput(
              title: 'Giá bán'.tr,
              initial: widget.tempProduct.unitSalePrice.toString(),
              readOnly: widget.readOnly,
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
                final unitSalePrice = int.tryParse(value);
                if (unitSalePrice != null) {
                  tempProduct = tempProduct.copyWith(unitSalePrice: unitSalePrice);
                  widget.onChanged(tempProduct);
                }
              },
            ),
            BoxWInput(
              title: 'Số lượng'.tr,
              initial: widget.tempProduct.count.toString(),
              readOnly: widget.readOnly,
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
                  widget.onChanged(tempProduct);
                }
              },
            ),
            if (widget.readOnly)
              BoxWInput(
                title: 'Loại hàng'.tr,
                initial: widget.categories.singleWhere((e) => e.id == tempProduct.categoryId).name,
                readOnly: true,
              )
            else
              Builder(
                builder: (context) {
                  return Row(
                    children: [
                      Expanded(
                        child: BoxWDropdown<int>(
                          title: 'Loại hàng'.tr,
                          items: dropdownItems(context),
                          value: widget.tempProduct.categoryId,
                          selectedItemBuilder: (_) {
                            return widget.categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList();
                          },
                          onChanged: (int? value) {
                            setState(() {
                              tempProduct = tempProduct.copyWith(categoryId: value);
                              widget.onChanged(tempProduct);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: widget.readOnly
                            ? null
                            : () async {
                                final nextId = await widget.notifier.getNextCategoryId();
                                if (context.mounted) {
                                  final category = await addCategoryDialog(context, nextId);
                                  if (category != null) {
                                    widget.categories.add(category);
                                    widget.validateForm();
                                    setState(() {});
                                  }
                                }
                              },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  );
                },
              ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    height: widget.tempProduct.imagePath.isEmpty ? null : 300,
                    width: double.infinity,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(
                            BoxWConfig.radius,
                          ),
                        ),
                        label: Text('Hình ảnh'.tr),
                      ),
                      child: widget.tempProduct.imagePath.isEmpty
                          ? Text(
                              'Chưa có hình ảnh'.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    ...PointerDeviceKind.values,
                                  },
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.tempProduct.imagePath.length,
                                  itemBuilder: (context, index) {
                                    final source = widget.tempProduct.imagePath.elementAt(index);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO(lamnhan066): Mở trình xem ảnh khi nhấn vào ảnh
                                        },
                                        child: widget.readOnly
                                            ? _ResolveImage(source: source)
                                            : Stack(
                                                children: [
                                                  _ResolveImage(source: source),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: CircleCloseButton(
                                                        onPressed: () async {
                                                          final isRemoved = await removeImageDialog(context);
                                                          if (isRemoved) {
                                                            setState(() {
                                                              tempProduct.imagePath.removeAt(index);
                                                            });
                                                            widget.validateForm();
                                                          }
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
                if (!widget.readOnly)
                  IconButton(
                    onPressed: () async {
                      final newImage = await addImageDialog(context);
                      if (newImage.isNotEmpty) {
                        tempProduct.imagePath.add(newImage);
                        widget.onChanged(tempProduct);
                        widget.validateForm();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
            BoxWInput(
              title: 'Mô tả'.tr,
              initial: widget.tempProduct.description,
              readOnly: widget.readOnly,
              onChanged: (value) {
                tempProduct = tempProduct.copyWith(description: value);
                widget.onChanged(tempProduct);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Kiểm tra `source` là URL hay Path để trả về ảnh.
class _ResolveImage extends StatelessWidget {
  const _ResolveImage({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    return source.startsWith('http') ? Image.network(source) : Image.file(File(source));
  }
}
