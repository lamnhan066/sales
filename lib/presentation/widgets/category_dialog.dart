import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';
import 'package:sales/domain/entities/category.dart';
import 'package:sales/presentation/providers/products_provider.dart';

Future<void> viewCategoryDialog(
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

Future<Category?> addCategoryDialog(BuildContext context, int nextId) async {
  final category = Category(
    id: nextId,
    name: '',
    description: '',
  );

  final newCategory = await _categoryDialog(
    context,
    'Thêm Loại Hàng'.tr,
    category,
  );

  if (newCategory != null) {
    return category;
  }

  return null;
}

/// Cập nhật category. Trả về `true` nếu có sự thay đổi.
Future<bool> updateCategoryDialog(
  BuildContext context,
  ProductsNotifier notifier,
  Category category,
) async {
  final c = await _categoryDialog(
    context,
    'Sửa Loại Hàng'.tr,
    category,
  );

  if (c != null) {
    return true;
  }

  return false;
}

Future<bool> removeCategoryDialog(
  BuildContext context,
  ProductsNotifier notifier,
  Category category,
) async {
  final result = await boxWConfirm(
    context: context,
    title: 'Xác nhận'.tr,
    content: 'Bạn có chắc muốn xoá loại hàng @{name} không?'.trP({'name': category.name}),
    confirmText: 'Đồng ý'.tr,
    cancelText: 'Huỷ'.tr,
  );

  if (result) {
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
