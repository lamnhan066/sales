import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/models/category.dart';
import 'package:sales/utils/utils.dart';

class ProductFilterDialog extends StatefulWidget {
  const ProductFilterDialog({
    super.key,
    required this.initialRangeValues,
    this.intialCategoryId,
    required this.categories,
    required this.onRangeValuesChanged,
    required this.onCategoryIdChanged,
  });

  final RangeValues initialRangeValues;
  final int? intialCategoryId;
  final List<Category> categories;
  final void Function(RangeValues values) onRangeValuesChanged;
  final void Function(int? value) onCategoryIdChanged;

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  late RangeValues values;
  late int? categoryId;

  @override
  void initState() {
    values = widget.initialRangeValues;
    startController.text = Utils.getPriceRangeText(values.start);
    endController.text = Utils.getPriceRangeText(values.end);
    categoryId = widget.intialCategoryId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    initial: Utils.getPriceRangeText(values.start),
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
                        values = RangeValues(start, values.end);
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                InkWell(
                  onTap: () {
                    startController.text = Utils.getPriceRangeText(0);
                    values = RangeValues(0, values.end);
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
                        values = RangeValues(values.start, end);
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                InkWell(
                  onTap: () {
                    endController.text =
                        Utils.getPriceRangeText(double.infinity);
                    values = RangeValues(
                      values.start,
                      double.infinity,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Utils.getPriceRangeText(double.infinity),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            Text('Lọc theo loại hàng'.tr),
            BoxWDropdown<int?>(
              title: 'Loại hàng'.tr,
              items: widget.categories
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
              value: categoryId,
              onChanged: (int? value) {
                categoryId = value;
                widget.onCategoryIdChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}