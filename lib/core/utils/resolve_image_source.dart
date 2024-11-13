import 'dart:io';

import 'package:flutter/material.dart';

Image resolveImageSource(String source) {
  return source.startsWith('http') ? Image.network(source) : Image.file(File(source));
}
