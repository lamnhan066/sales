extension IntExtension on int {
  String to2Digits() {
    return toString().padLeft(2, '0');
  }
}
