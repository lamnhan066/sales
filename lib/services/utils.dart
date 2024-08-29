import 'package:encrypt/encrypt.dart' as e;

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
