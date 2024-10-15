import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sales/core/extensions/data_time_extensions.dart';

extension DoubleRangesExtension on Ranges<double> {
  bool get isAllPrices => start == 0 && end == double.infinity;
}

class Ranges<T extends Object?> with EquatableMixin {
  final T start;
  final T end;

  const Ranges(this.start, this.end);

  Ranges<T> copyWith({
    T? start,
    T? end,
  }) {
    return Ranges<T>(start ?? this.start, end ?? this.end);
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  factory Ranges.fromMap(Map<String, dynamic> map) {
    return Ranges<T>(map['start'] as T, map['end'] as T);
  }

  String toJson() => json.encode(toMap());

  factory Ranges.fromJson(String source) => Ranges.fromMap(json.decode(source));

  @override
  String toString() => 'Ranges(start: $start, end: $end)';

  @override
  List<Object> get props => [start ?? '', end ?? ''];
}

class WeekDaysRanges extends Ranges<DateTime> {
  final DateTime date;

  /// Khoảng ngày từ đầu tuần đến cuối tuần nhưng không vượt quá ngày hiện tại.
  WeekDaysRanges(this.date) : super(_getStartDate(date), _getEndDate(date));

  static DateTime _getStartDate(DateTime date) {
    for (int i = 0;; i++) {
      final previousDate = date.subtract(Duration(days: i)).dateOnly();
      if (previousDate.weekday == 1) return previousDate;
    }
  }

  static DateTime _getEndDate(DateTime date) {
    final today = DateTime.now().dateOnly();
    for (int i = 0;; i++) {
      final nextDate = date.add(Duration(days: i)).dateOnly();
      if (nextDate.weekday == 1 || nextDate == today) return today;
    }
  }
}

class MonthDaysRanges extends Ranges<DateTime> {
  final DateTime date;

  /// Khoảng ngày từ đầu tháng cho đến cuối tháng nhưng không vượt quá ngày hiện tại.
  MonthDaysRanges(this.date) : super(_getStartDate(date), _getEndDate(date));

  static DateTime _getStartDate(DateTime date) {
    for (int i = 0;; i++) {
      final previousDate = date.subtract(Duration(days: i)).dateOnly();
      if (previousDate.day == 1) return previousDate;
    }
  }

  static DateTime _getEndDate(DateTime date) {
    final today = DateTime.now().dateOnly();
    // Tìm ngày đầu của tháng tiếp theo nên cầu bắt đầu là 1 thay vì 0.
    for (int i = 1;; i++) {
      final nextDate = date.add(Duration(days: i)).dateOnly();
      if (nextDate.day == 1 || nextDate == today) return today;
    }
  }
}
