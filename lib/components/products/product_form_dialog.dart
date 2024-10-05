import 'dart:io';
import 'dart:ui';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/product.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({
    super.key,
    required this.controller,
    required this.form,
    required this.categories,
    required this.validateForm,
    required this.tempProduct,
    required this.readOnly,
    required this.onChanged,
  });

  final ProductController controller;
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
                    widget.controller.infoCategory(context, e);
                  },
                  icon: const Icon(
                    Icons.info_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await widget.controller.editCategory(
                      context,
                      setState,
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
                    final result = await widget.controller.removeCategory(
                      context,
                      setState,
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
                initial: widget.categories
                    .singleWhere((e) => e.id == tempProduct.categoryId)
                    .name,
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
                              tempProduct =
                                  tempProduct.copyWith(categoryId: value);
                              widget.onChanged(tempProduct);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: widget.readOnly
                            ? null
                            : () {
                                widget.controller
                                    .addCategory(context, setState);
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    ...PointerDeviceKind.values,
                                  },
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.tempProduct.imagePath.length,
                                  itemBuilder: (context, index) {
                                    final source = widget.tempProduct.imagePath
                                        .elementAt(index);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: Mở trình xem ảnh khi nhấn vào ảnh
                                        },
                                        child: widget.readOnly
                                            ? _ResolveImage(source: source)
                                            : Stack(
                                                children: [
                                                  _ResolveImage(source: source),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleCloseButton(
                                                        onPressed: () async {
                                                          await widget
                                                              .controller
                                                              .removeImage(
                                                            context,
                                                            tempProduct
                                                                .imagePath,
                                                            index,
                                                            widget.validateForm,
                                                          );
                                                          setState(() {});
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
                      await widget.controller.addImage(
                        context,
                        widget.tempProduct.imagePath,
                        widget.validateForm,
                      );
                      setState(() {});
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
    return source.startsWith('http')
        ? Image.network(source)
        : Image.file(File(source));
  }
}
