import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/core/constants/app_configs.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/domain/entities/product.dart';
import 'package:sales/presentation/riverpod/products_provider.dart';
import 'package:sales/presentation/widgets/common_components.dart';
import 'package:sales/presentation/widgets/product_form_dialog.dart';

Future<Product?> viewProductDialog({
  required BuildContext context,
  required ProductsNotifier notifier,
  required Product product,
  required List<Category> categories,
}) {
  return _productDialog(
    context: context,
    notifier: notifier,
    title: 'Thông Tin Sản Phẩm'.tr,
    product: product,
    categories: categories,
    generateIdSku: false,
    readOnly: true,
  );
}

Future<Product?> addProductDialog({
  required BuildContext context,
  required ProductsNotifier notifier,
  required List<Category> categories,
}) {
  return _productDialog(
    context: context,
    notifier: notifier,
    title: 'Thêm Sản Phẩm'.tr,
    product: null,
    generateIdSku: true,
    categories: categories,
  );
}

Future<Product?> updateProductDialog({
  required BuildContext context,
  required ProductsNotifier notifier,
  required List<Category> categories,
  required Product product,
}) {
  return _productDialog(
    context: context,
    notifier: notifier,
    title: 'Sửa Sản Phẩm'.tr,
    product: product,
    generateIdSku: false,
    categories: categories,
  );
}

Future<Product?> copyProductDialog({
  required BuildContext context,
  required ProductsNotifier notifier,
  required List<Category> categories,
  required Product product,
}) {
  return _productDialog(
    context: context,
    notifier: notifier,
    title: 'Chép Sản Phẩm'.tr,
    product: product,
    generateIdSku: true,
    categories: categories,
  );
}

Future<bool> removeProductDialog(
  BuildContext context,
  Product product,
) async {
  final result = await boxWConfirm(
    context: context,
    title: 'Xác nhận'.tr,
    content: 'Bạn có chắc muốn xoá sản phẩm @{name} không?'.trP({
      'name': product.name,
    }),
    confirmText: 'Đồng ý'.tr,
    cancelText: 'Huỷ'.tr,
  );

  return result;
}

Future<Product?> _productDialog({
  required BuildContext context,
  required ProductsNotifier notifier,
  required String title,
  required Product? product,
  required bool generateIdSku,
  bool readOnly = false,
  required List<Category> categories,
}) async {
  Product tempProduct = product?.copyWith(imagePath: [...product.imagePath]) ??
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
    final idSku = await notifier.getNextProductIdAndSku();
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
        maxWidth: MediaQuery.sizeOf(context).width * AppConfigs.dialogWidthRatio,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * AppConfigs.dialogWidthRatio,
        ),
        child: ProductFormDialog(
          notifier: notifier,
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
