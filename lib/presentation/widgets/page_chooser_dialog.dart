import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/presentation/widgets/common_components.dart';

/// Hiển thị dialog để chọn trang.
///
/// Trả về số nếu chọn trang mới.
/// Trả về null nếu huỷ hoặc trang được chọn giống với trang hiện tại.
Future<int?> pageChooser({
  required BuildContext context,
  required int page,
  required int totalPage,
}) async {
  var tempPage = page;
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

  final result = await boxWDialog<bool>(
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
        confirmCancelButtons(
          context: context,
          enableConfirmStream: validatorController.stream,
          confirmText: 'OK'.tr,
          cancelText: 'Huỷ'.tr,
        ),
      ];
    },
  );

  await validatorController.close();

  if ((result ?? false) && tempPage != page) {
    return tempPage;
  }

  return null;
}
