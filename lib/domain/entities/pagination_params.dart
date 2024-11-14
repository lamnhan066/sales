import 'package:equatable/equatable.dart';

class PaginationParams with EquatableMixin {
  PaginationParams({
    required this.page,
    required this.perpage,
  });

  final int page;
  final int perpage;

  PaginationParams copyWith({
    int? page,
    int? perpage,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      perpage: perpage ?? this.perpage,
    );
  }

  @override
  List<Object> get props => [page, perpage];
}
