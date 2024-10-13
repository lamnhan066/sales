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
