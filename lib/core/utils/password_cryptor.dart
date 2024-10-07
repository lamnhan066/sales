import 'package:encrypt/encrypt.dart' as e;
import 'package:sales/domain/entities/credentials.dart';

/// Bảo mật mật khẩu.
class PasswordCryptor {
  /// Mã hoá mật khẩu.
  static String encryptPassword(Credentials credentials) {
    final iv = e.IV.fromLength(16);
    final key = e.Key.fromUtf8('${credentials.username}${credentials.entropy}'.padRight(32, '!'));
    final encryptor = e.Encrypter(e.AES(key));
    final encrypted = encryptor.encrypt(credentials.password, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  /// Giải mã mật khẩu.
  static String decryptPassword(Credentials credentials) {
    final parts = credentials.password.split(':');
    final iv = e.IV.fromBase64(parts[0]);
    final encryptedText = parts[1];
    final key = e.Key.fromUtf8('${credentials.username}${credentials.entropy}'.padRight(32, '!'));
    final encryptor = e.Encrypter(e.AES(key));

    return encryptor.decrypt64(encryptedText, iv: iv);
  }
}
