import 'package:flutter/material.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:provider/provider.dart';

Future<bool> clearImageUploadProvider() async {
  final context = navigatorKey.currentContext!;
  final _provider = Provider.of<ImageUploadProvider>(
    context,
    listen: false,
  );
  _provider.clearImageFile();
  Navigator.pop(context);
  return false;
}
