import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

Future<File> compressImage(File file) async {
  try {
    final fileExt = p.extension(file.path);
    final dirName = p.dirname(file.path);
    final baseName = p.basenameWithoutExtension(file.path);
    final targetPath = "$dirName/${baseName}_out$fileExt";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 50,
    );
    return result!;
  } catch (e) {
    throw Exception(e);
  }
}
