import 'package:equatable/equatable.dart';
import 'package:sales/domain/entities/ranges.dart';

class GetOrderParams with EquatableMixin {

  const GetOrderParams({
    this.page = 1,
    this.perpage = 10,
    this.dateRange,
  });
  final int page;
  final int perpage;
  final Ranges<DateTime?>? dateRange;

  @override
  List<Object?> get props => [page, perpage, dateRange];
}
