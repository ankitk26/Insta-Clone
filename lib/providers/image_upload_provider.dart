import 'dart:io';
import 'package:flutter/material.dart';

class ImageUploadProvider with ChangeNotifier {
  File? _imageFile;

  File? get imageFile => _imageFile;

  void setImageFile(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void clearImageFile() {
    _imageFile = null;
    notifyListeners();
  }
}
