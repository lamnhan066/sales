import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  /// dd/MM/yyyy
  String toddMMyyyy() {
    final dd = '$day'.padLeft(2, '0');
    final mm = '$month'.padLeft(2, '0');
    return '$dd/$mm/$year';
  }

  /// yyyy-M-d
  String toyyyyMd() {
    return '$year-$month-$day';
  }

  /// MM-yyyy
  String tommyyyy() {
    final mm = '$month'.padLeft(2, '0');
    return '$mm-$year';
  }

  // HH:mm:ss dd/MM/yyyy
  String toHHmmssddMMyyyy() {
    final hh = '$hour'.padLeft(2, '0');
    final mm = '$minute'.padLeft(2, '0');
    final ss = '$second'.padLeft(2, '0');
    return '$hh:$mm:$ss ${toddMMyyyy()}';
  }

  /// Date only
  DateTime dateOnly() {
    return DateUtils.dateOnly(this);
  }
}
