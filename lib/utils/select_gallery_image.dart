import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:provider/provider.dart';

Future<void> selectGalleryImage() async {
  final _provider = Provider.of<ImageUploadProvider>(
    navigatorKey.currentContext!,
    listen: false,
  );

  final _image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (_image == null) return;

  final _chosenImage = File(_image.path);
  _provider.setImageFile(_chosenImage);
}
