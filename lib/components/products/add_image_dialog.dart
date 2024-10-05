// ignore_for_file: function_lines_of_code, cyclomatic_complexity

import 'package:boxw/boxw.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';

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
