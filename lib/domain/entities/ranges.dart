import 'dart:convert';

import 'package:equatable/equatable.dart';

extension DoubleRangesExtension on Ranges<double> {
  bool get isAllPrices => start == 0 && end == double.infinity;
}

class Ranges<T extends Object?> with EquatableMixin {

  const Ranges(this.start, this.end);

  factory Ranges.fromMap(Map<String, dynamic> map) {
    return Ranges<T>(map['start'] as T, map['end'] as T);
  }

  factory Ranges.fromJson(String source) => Ranges.fromMap(json.decode(source));
  final T start;
  final T end;

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

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Ranges(start: $start, end: $end)';

  @override
  List<Object> get props => [start ?? '', end ?? ''];
}

class SevenDaysRanges extends Ranges<DateTime> {

  /// Khoảng thời gian bảy ngày cho đến ngày hiện tại là [date].
  SevenDaysRanges(this.date) : super(date.subtract(const Duration(days: 7)), date);
  final DateTime date;
}

class ThirtyDaysRanges extends Ranges<DateTime> {

  /// Khoảng thời gian 30 ngày cho đến ngày hiện tại là [date].
  ThirtyDaysRanges(this.date) : super(date.subtract(const Duration(days: 30)), date);
  final DateTime date;
}
