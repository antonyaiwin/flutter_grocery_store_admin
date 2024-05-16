import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> getCompressedImageData(
  File file, {
  int minWidth = 300,
  int minHeight = 300,
  int quality = 70,
}) async {
  var result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: minWidth,
    minHeight: minHeight,
    quality: quality,
  );
  log(file.lengthSync().toString());
  log(result!.length.toString());
  return result;
}
