import 'dart:convert';

import 'package:equatable/equatable.dart';

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

class SevenDaysRanges extends Ranges<DateTime> {
  final DateTime date;

  SevenDaysRanges(this.date) : super(_getStartDate(date), _getEndDate(date));

  static DateTime _getStartDate(DateTime date) {
    for (int i = 0;; i++) {
      final previousDate = date.subtract(Duration(days: i));
      if (previousDate.weekday == 1) return previousDate;
    }
  }

  static DateTime _getEndDate(DateTime date) {
    for (int i = 0;; i++) {
      final nextDate = date.add(Duration(days: i));
      if (nextDate.weekday == 1) return nextDate;
    }
  }
}

class MonthDaysRanges extends Ranges<DateTime> {
  final DateTime date;

  MonthDaysRanges(this.date) : super(_getStartDate(date), _getEndDate(date));

  static DateTime _getStartDate(DateTime date) {
    for (int i = 0;; i++) {
      final previousDate = date.subtract(Duration(days: i));
      if (previousDate.day == 1) return previousDate;
    }
  }

  static DateTime _getEndDate(DateTime date) {
    // Tìm ngày đầu của tháng tiếp theo nên cầu bắt đầu là 1 thay vì 0.
    for (int i = 1;; i++) {
      final nextDate = date.add(Duration(days: i));
      if (nextDate.day == 1) return nextDate;
    }
  }
}
