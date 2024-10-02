import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as e;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class PasswordCryptor {
  static String encrypt(String username, String password) {
    final iv = e.IV.fromUtf8(username.padRight(16, '!'));
    final key = e.Key.fromUtf8(username.padRight(32, '#'));
    final encryptor = e.Encrypter(e.AES(key));
    return encryptor.encrypt(password, iv: iv).base64;
  }

  static String decrypt(String username, String encryptedPassword) {
    final iv = e.IV.fromUtf8(username.padRight(16, '!'));
    final key = e.Key.fromUtf8(username.padRight(32, '#'));
    final encryptor = e.Encrypter(e.AES(key));
    return encryptor.decrypt64(encryptedPassword, iv: iv);
  }
}

class Utils {
  static String formatDateTime(DateTime date) {
    String padLeft2(int number) {
      return '$number'.padLeft(2, '0');
    }

    final hour = padLeft2(date.hour);
    final minute = padLeft2(date.minute);
    final day = padLeft2(date.day);
    final month = padLeft2(date.month);
    return '${hour}h$minute $day/$month/${date.year}';
  }

  static Future<Excel?> getExcelFile() async {
    try {
      final FilePickerResult? file = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (file != null && file.files.isNotEmpty) {
        final Uint8List bytes = file.files.first.bytes!;

        return Excel.decodeBytes(bytes);
      } else {
        return null;
      }
    } on Exception {
      rethrow;
    }
  }

  static String dateToSql(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
