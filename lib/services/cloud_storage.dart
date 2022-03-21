import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/utils/compress_image.dart';
import 'package:path/path.dart' as p;

class CloudStorage {
  final storage = FirebaseStorage.instance;

  Future<String> uploadImagetoCloud({
    required File file,
    required String folder,
  }) async {
    try {
      final fileExt = p.extension(file.path);
      final fileName = p.basenameWithoutExtension(file.path);
      final compressedFile = await compressImage(file);
      final result = await storage
          .ref("$folder/$fileName.$fileExt")
          .putFile(compressedFile);
      final downloadUrl = await result.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      return "error";
    }
  }
}
