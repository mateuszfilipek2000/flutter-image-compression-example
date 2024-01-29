import 'dart:typed_data';

import 'package:compression/src/image_compressor/image_compressor.dart';
import 'package:compression/src/rust/api/compress.dart' as rust;

ImageCompressor getImageCompressorImpl() => ImageCompressorIO();

final class ImageCompressorIO implements ImageCompressor {
  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    final rustCompressed = await rust.compress(imageBytes: bytes);

    return Uint8List.fromList(rustCompressed);
  }
}
