import 'dart:async';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:compression/src/image_compressor/image_compressor.dart';

ImageCompressor getImageCompressorImpl() => ImageCompressorHTML();

class ImageCompressorHTML implements ImageCompressor {
  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final image = html.ImageElement(src: url);
    final completer = Completer<Uint8List>();

    image.onLoad.listen((event) {
      final canvas =
          html.CanvasElement(width: image.width, height: image.height);
      final context = canvas.context2D;

      context.drawImage(image, 0, 0);

      canvas.toBlob('image/jpeg', 0.5).then((blob) {
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          final buffer = reader.result as Uint8List;

          completer.complete(buffer);
        });

        reader.readAsArrayBuffer(blob);
      });
    });

    return completer.future;
  }
}
