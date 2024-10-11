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
