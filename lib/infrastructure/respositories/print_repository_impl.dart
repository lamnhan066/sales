import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sales/domain/repositories/print_repository.dart';

class PrintRepositoryImpl implements PrintRepository {
  @override
  Future<void> printImageBytesAsPdf(Uint8List bytes) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(build: (context) => pw.Image(pw.MemoryImage(bytes))));
    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }
}
