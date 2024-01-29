import 'dart:typed_data';

import 'package:compression/src/image_compressor/image_compressor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:compression/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  (List<int> originalBytes, List<int> compressedBytes)? imageData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: switch (imageData) {
          final data? => Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.memory(
                        Uint8List.fromList(data.$1),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      // size in mega bytes
                      Text(
                          'Original size: ${(data.$1.length / 1024 / 1024).toStringAsFixed(2)} MB'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.memory(
                        Uint8List.fromList(data.$2),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      Text(
                          'Compressed size: ${(data.$2.length / 1024 / 1024).toStringAsFixed(2)} MB'),
                    ],
                  ),
                ),
              ],
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final file = await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
              );

              final bytes = file?.files.firstOrNull?.bytes;

              if (bytes == null) return;

              final data = await ImageCompressor().compress(bytes);

              setState(() => imageData = (bytes, data));
            },
            child: const Icon(Icons.compress)),
      ),
    );
  }
}
