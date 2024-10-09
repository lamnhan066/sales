import 'package:equatable/equatable.dart';

class GetResult<T> with EquatableMixin {
  final int totalCount;
  final List<T> items;

  GetResult({
    required this.totalCount,
    required this.items,
  });

  @override
  List<Object> get props => [totalCount, items];
}
