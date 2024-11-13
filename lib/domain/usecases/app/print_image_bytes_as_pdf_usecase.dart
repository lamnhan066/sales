import 'dart:typed_data';

import 'package:sales/core/usecases/usecase.dart';
import 'package:sales/domain/repositories/print_repository.dart';

class PrintImageBytesAsPdfUseCase implements UseCase<void, Uint8List> {

  const PrintImageBytesAsPdfUseCase(this._repository);
  final PrintRepository _repository;

  @override
  Future<void> call(Uint8List bytes) {
    return _repository.printImageBytesAsPdf(bytes);
  }
}
