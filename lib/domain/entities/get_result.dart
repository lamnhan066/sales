import 'package:equatable/equatable.dart';

class GetResult<T> with EquatableMixin {

  GetResult({
    required this.totalCount,
    required this.items,
  });
  final int totalCount;
  final List<T> items;

  @override
  List<Object> get props => [totalCount, items];
}
