import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart' hide DataCell, DataColumn, DataRow, DataTable;
import 'package:language_helper/language_helper.dart';
import 'package:sales/presentation/widgets/data_table_plus.dart';

/// Nút tắt
class CircleCloseButton extends StatelessWidget {
  /// Nút tắt
  const CircleCloseButton({
    super.key,
    this.onPressed,
  });

  /// Calback của nút tắt khi được nhấn.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        color: Colors.white,
        icon: const Icon(
          Icons.close_rounded,
          size: 16,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

Buttons confirmCancelButtons({
  required BuildContext context,
  Stream<bool>? enableConfirmStream,
  String? confirmText,
  String? cancelText,
  bool hideCancel = false,
}) {
  final confirm = confirmText ??= 'Xác nhận'.tr;
  final cancel = cancelText ??= 'Trở về'.tr;
  return Buttons(
    axis: Axis.horizontal,
    buttons: [
      StreamBuilder<bool>(
        stream: enableConfirmStream,
        initialData: enableConfirmStream == null ? true : null,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FilledButton(
              onPressed: !snapshot.hasData || snapshot.data != true
                  ? null
                  : () {
                      Navigator.pop(context, true);
                    },
              child: Text(confirm),
            ),
          );
        },
      ),
      if (!hideCancel)
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(cancel),
          ),
        ),
    ],
  );
}

DataColumn headerTextColumn(String text, {bool numeric = false}) {
  return DataColumn(
    numeric: numeric,
    headingRowAlignment: MainAxisAlignment.center,
    label: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
