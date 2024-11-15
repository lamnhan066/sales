import 'dart:convert';

import 'package:equatable/equatable.dart';

sealed class License with EquatableMixin {
  const License({
    required this.activeDate,
    required this.expiredDays,
    required this.isTrial,
  });
  final DateTime? activeDate;
  final int expiredDays;
  final bool isTrial;

  bool get isExpired => activeDate == null || activeDate!.add(Duration(days: expiredDays)).isBefore(DateTime.now());
  int get remainingDays {
    if (activeDate == null) return 0;

    return activeDate!.add(Duration(days: expiredDays)).difference(DateTime.now()).inDays;
  }

  License copyWith({
    DateTime? activeDate,
    int? expiredDays,
    bool? isTrial,
  }) {
    return License.fromMap({
      'activateDate': activeDate?.millisecondsSinceEpoch ?? this.activeDate?.millisecondsSinceEpoch,
      'expiredDays': expiredDays ?? this.expiredDays,
      'isTrial': isTrial ?? this.isTrial,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'activateDate': activeDate?.millisecondsSinceEpoch,
      'expiredDays': expiredDays,
      'isTrial': isTrial,
    };
  }

  static License fromMap(Map<String, dynamic> map) {
    if (map['activateDate'] == null) {
      return const NoLicense();
    }

    final activeDate = DateTime.fromMillisecondsSinceEpoch(map['activateDate']);
    final int expiredDays = map['expiredDays']?.toInt() ?? 0;
    final bool isTrial = map['isTrial'] ?? false;

    return isTrial
        ? TrialLicense(activeDate, expiredDays)
        : (activeDate == DateTime(0) && expiredDays == 0)
            ? const NoLicense()
            : ActiveLicense(activeDate, expiredDays);
  }

  String toJson() => json.encode(toMap());

  static License fromJson(String source) {
    return License.fromMap(json.decode(source));
  }

  @override
  List<Object?> get props => [activeDate, expiredDays, isTrial];
}

class NoLicense extends License {
  const NoLicense() : super(activeDate: null, expiredDays: 0, isTrial: false);
}

class TrialLicense extends License {
  TrialLicense(DateTime activeDate, [int expiredDays = 15])
      : super(activeDate: activeDate, expiredDays: expiredDays, isTrial: true);
}

class ActiveLicense extends License {
  ActiveLicense(DateTime activeDate, int expiredDays)
      : super(activeDate: activeDate, expiredDays: expiredDays, isTrial: false);
}
