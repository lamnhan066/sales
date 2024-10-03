import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';

/// Hiển thị dialog để chọn trang.
///
/// Trả về số nếu chọn trang mới.
/// Trả về null nếu huỷ hoặc trang được chọn giống với trang hiện tại.
Future<int?> pageChooser({
  required BuildContext context,
  required int page,
  required int totalPage,
}) async {
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

  await validatorController.close();

  if (result == true && tempPage != page) {
    return tempPage;
  }

  return null;
}
