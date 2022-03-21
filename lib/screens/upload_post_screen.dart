import 'package:flutter/material.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/cloud_storage.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/utils/clear_image_upload_provider.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/select_gallery_image.dart';
import 'package:insta_clone/utils/show_loading_modal.dart';
import 'package:provider/provider.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  static const routeName = "/upload-post";

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();

  Future<void> _uploadPost() async {
    final _provider = Provider.of<ImageUploadProvider>(context, listen: false);

    // If no file is selected return
    if (_provider.imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          dismissDirection: DismissDirection.startToEnd,
          content: Text("Image is required"),
        ),
      );
      return;
    }

    showLoadingModal(message: "Uploading post");

    // Get image URL after uploading to cloud
    final imageUrlFromStorage = await CloudStorage().uploadImagetoCloud(
      file: _provider.imageFile!,
      folder: "posts",
    );

    // Return if something went wrong in cloud uploading
    if (imageUrlFromStorage == "error") return;

    // Write data to firestore
    await PostService().newPost({
      "caption": _captionController.text,
      "imageUrl": imageUrlFromStorage,
      "location": _locationController.text,
      "userId": AuthService().userId,
    });

    // Close loading modal
    Navigator.of(context).pop();

    // Clean-up data after uploading post
    _captionController.clear();
    _locationController.clear();
    _provider.clearImageFile();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clearImageUploadProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New post"),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: _uploadPost,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: spacing,
              horizontal: spacing * 1.25,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: spacing),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: selectGalleryImage,
                      child: Text(
                        "Choose photo",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Consumer<ImageUploadProvider>(
                      builder: (context, _provider, _) {
                        if (_provider.imageFile != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: spacing),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(spacing)),
                              child: Image.file(
                                _provider.imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: spacing * 2),
                    TextFormField(
                      minLines: 3,
                      maxLines: 15,
                      controller: _captionController,
                      decoration: textFieldDecoration.copyWith(
                        labelText: "Caption",
                      ),
                    ),
                    const SizedBox(height: spacing * 2),
                    TextFormField(
                      controller: _locationController,
                      decoration: textFieldDecoration.copyWith(
                        labelText: "Location",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
