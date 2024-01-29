import 'dart:typed_data';

import 'package:compression/src/image_compressor/image_compressor_stub.dart'
    if (dart.library.io) 'package:compression/src/image_compressor/image_compressor_io.dart'
    if (dart.library.html) 'package:compression/src/image_compressor/image_compressor_html.dart';

abstract interface class ImageCompressor {
  factory ImageCompressor() => getImageCompressorImpl();

  Future<Uint8List> compress(Uint8List bytes);
}
