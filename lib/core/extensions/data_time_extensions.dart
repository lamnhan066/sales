import 'package:flutter/material.dart';
import 'package:sales/core/extensions/int_extensions.dart';

extension DateTimeExtensions on DateTime {
  /// dd/MM/yyyy
  String toddMMyyyy() {
    final dd = day.to2Digits();
    final mm = month.to2Digits();
    return '$dd/$mm/$year';
  }

  /// yyyy-M-d
  String toyyyyMd() {
    return '$year-$month-$day';
  }

  /// MM-yyyy
  String tommyyyy() {
    final mm = month.to2Digits();
    return '$mm-$year';
  }

  // HH:mm:ss dd/MM/yyyy
  String toHHmmssddMMyyyy() {
    final hh = hour.to2Digits();
    final mm = minute.to2Digits();
    final ss = second.to2Digits();
    return '$hh:$mm:$ss ${toddMMyyyy()}';
  }

  /// Date only
  DateTime dateOnly() {
    return DateUtils.dateOnly(this);
  }
}
