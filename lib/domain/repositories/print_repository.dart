import 'dart:typed_data';

abstract class PrintRepository {
  Future<void> printImageBytesAsPdf(Uint8List bytes);
}
