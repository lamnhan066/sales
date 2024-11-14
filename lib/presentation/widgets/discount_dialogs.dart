import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/domain/entities/add_discount_params.dart';
import 'package:sales/presentation/riverpod/notifiers/discount_provider.dart';
import 'package:sales/presentation/widgets/common_components.dart';

Future<void> addDiscountDialog(BuildContext context, DiscountNotifier notifier) async {
  String? validatePercent(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) return 'Vui lòng chỉ nhập số'.tr;
    final number = int.parse(value);
    if (number < 0) return 'Số phải lớn hơn 0'.tr;
    if (number > 100) return 'Số phải <= 100'.tr;
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || int.tryParse(value) == null) {
      return 'Vui lòng chỉ nhập số'.tr;
    }

    return null;
  }

  var percent = '0';
  var maxPrice = '0';
  var numberOfDiscounts = 1;
  var validPercent = validatePercent('');
  var validPrice = validatePrice('');
  var isUnlimited = true;
  final validatorController = StreamController<bool>();

  void validateStream() {
    if ((validPrice == null || isUnlimited) && validPercent == null) {
      validatorController.sink.add(true);
    } else {
      validatorController.sink.add(false);
    }
  }

  final result = await boxWDialog<bool>(
    context: context,
    title: 'Thêm Mã Giảm Giá'.tr,
    constrains: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 2 / 3),
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            BoxWInput(
              title: 'Số % giảm (0 - 100)'.tr,
              keyboardType: TextInputType.number,
              validator: (value) {
                validPercent = validatePercent(value);
                validateStream();
                return validPercent;
              },
              onChanged: (value) {
                percent = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số lượng mã'.tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 100,
                    child: BoxWNumberField(
                      initial: numberOfDiscounts,
                      min: 1,
                      max: 1000,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            numberOfDiscounts = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            BoxWInput(
              enabled: !isUnlimited,
              title: 'Giá giảm tối đa'.tr,
              keyboardType: TextInputType.number,
              validator: (value) {
                validPrice = validatePrice(value);
                validateStream();
                return validPrice;
              },
              onChanged: (value) {
                maxPrice = value;
              },
            ),
            CheckboxListTile(
              title: SizedBox(
                width: 280,
                child: Text('Không giới hạn giá giảm'.tr),
              ),
              value: isUnlimited,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    isUnlimited = value;
                  });
                  validateStream();
                }
              },
            ),
          ],
        );
      },
    ),
    buttons: (ctx) => [
      confirmCancelButtons(
        context: ctx,
        confirmText: 'Thêm'.tr,
        enableConfirmStream: validatorController.stream,
      ),
    ],
  );

  await validatorController.close();

  if (result ?? false) {
    await notifier.addDiscountUseCase(
      AddDiscountParams(
        percent: int.parse(percent),
        maxPrice: int.parse(maxPrice),
        numberOfDiscounts: numberOfDiscounts,
      ),
    );
  }
}
