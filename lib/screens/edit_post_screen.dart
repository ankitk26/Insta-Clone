import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/services/cloud_storage.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/utils/clear_image_upload_provider.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/select_gallery_image.dart';
import 'package:insta_clone/utils/show_loading_modal.dart';
import 'package:provider/provider.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;
  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  static const routeName = "/edit-post";

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  String _postImage = "";
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    _postImage = widget.post.imageUrl;
    _captionController.text = widget.post.caption ?? "";
    _locationController.text = widget.post.location ?? "";
    super.initState();
  }

  Future<void> _updatePost() async {
    final _provider = Provider.of<ImageUploadProvider>(context, listen: false);

    // Initialize postImage to _postImage if post image is not changed
    String _postImageUrl = _postImage;

    // Show loading modal
    showLoadingModal(message: "Updating post");

    // If file is selected, get image URL from cloud
    if (_provider.imageFile != null) {
      _postImageUrl = await CloudStorage().uploadImagetoCloud(
        file: _provider.imageFile!,
        folder: "posts",
      );
    }

    // Final data to be updated
    final _updatedPostJson = {
      "caption": _captionController.text,
      "imageUrl": _postImageUrl,
      "location": _locationController.text,
    };

    // Update data in Firestore
    await PostService().updatePost(
      updatedPostJson: _updatedPostJson,
      postId: widget.post.id,
    );

    // Close loading modal
    Navigator.pop(context);

    // Redirect to post item
    Navigator.pop(context);

    // Clear image file in provider
    _provider.clearImageFile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clearImageUploadProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit post"),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: _updatePost,
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
                    _EditPostImage(postImageUrl: widget.post.imageUrl),
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

class _EditPostImage extends StatelessWidget {
  final String postImageUrl;
  const _EditPostImage({Key? key, required this.postImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.only(top: spacing),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(spacing)),
            child: Consumer<ImageUploadProvider>(
              builder: (context, _provider, _) {
                if (_provider.imageFile != null) {
                  return Image.file(
                    _provider.imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  );
                }
                return Image.network(
                  postImageUrl,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        Consumer<ImageUploadProvider>(
          builder: (context, _provider, _) {
            if (_provider.imageFile != null) {
              return Padding(
                padding: const EdgeInsets.only(top: spacing),
                child: InkWell(
                  onTap: () {
                    _provider.clearImageFile();
                  },
                  child: Text(
                    "UNDO",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
