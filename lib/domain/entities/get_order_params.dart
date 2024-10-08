import 'package:sales/domain/entities/ranges.dart';

class GetOrderParams {
  final int page;
  final int perpage;
  final Ranges<DateTime>? dateRange;

  const GetOrderParams({
    this.page = 1,
    this.perpage = 10,
    this.dateRange,
  });
}
