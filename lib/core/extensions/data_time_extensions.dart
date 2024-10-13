import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  String toddMMyyyy() {
    final dd = '$day'.padLeft(2, '0');
    final mm = '$month'.padLeft(2, '0');
    return '$dd/$mm/$year';
  }

  /// yyyy-MM-dd
  String toyyyyMd() {
    return '$year-$month-$day';
  }

  /// MM-yyyy
  String tommyyyy() {
    final mm = '$month'.padLeft(2, '0');
    return '$mm-$year';
  }

  /// Date only
  DateTime dateOnly() {
    return DateUtils.dateOnly(this);
  }
}
