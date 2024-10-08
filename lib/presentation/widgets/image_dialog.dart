// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'dart:async';

import 'package:boxw/boxw.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/components/common_components.dart';

Future<String> addImageDialog(BuildContext context) async {
  String path = '';
  final pathStreamController = StreamController<bool>();
  final textController = TextEditingController();
  final isAccepted = await boxWDialog(
    context: context,
    title: 'Thêm Ảnh'.tr,
    content: AddImageDialog(
      pathController: textController,
      onChanged: (value) {
        path = value;
        pathStreamController.add(value != '');
        textController.text = path;
      },
    ),
    buttons: (ctx) {
      return [
        confirmCancelButtons(
          context: context,
          enableConfirmStream: pathStreamController.stream,
          confirmText: 'Thêm'.tr,
          cancelText: 'Huỷ'.tr,
        ),
      ];
    },
  );

  await pathStreamController.close();

  if (isAccepted == true && path.isNotEmpty) {
    return path;
  }

  return '';
}

Future<bool> removeImageDialog(BuildContext context) async {
  final isRemoved = await boxWConfirm(
    context: context,
    title: 'Xoá Ảnh'.tr,
    content: 'Bạn có chắc muốn xoá ảnh này không?'.tr,
    confirmText: 'Có'.tr,
    cancelText: 'Không'.tr,
  );

  return isRemoved;
}

class AddImageDialog extends StatelessWidget {
  const AddImageDialog({
    super.key,
    required this.pathController,
    required this.onChanged,
  });

  final TextEditingController pathController;
  final void Function(String path) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Vui lòng chọn ảnh từ đường dẫn\ntừ máy hoặc internet'.tr,
          textAlign: TextAlign.center,
        ),
        BoxWInput(
          controller: pathController,
          title: 'Đường dẫn'.tr,
          maxLines: 10,
          onChanged: onChanged,
        ),
        TextButton(
          onPressed: () async {
            final picked = await FilePicker.platform.pickFiles(
              dialogTitle: 'Chọn ảnh',
              type: FileType.image,
            );

            if (picked != null && picked.count > 0) {
              onChanged(picked.files.first.path!);
            }
          },
          child: Text('Chọn ảnh từ máy'.tr),
        ),
      ],
    );
  }
}
