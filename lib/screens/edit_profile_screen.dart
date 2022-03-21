import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/services/cloud_storage.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/bottom_sheet_container.dart';
import 'package:insta_clone/utils/clear_image_upload_provider.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/select_gallery_image.dart';
import 'package:insta_clone/utils/show_loading_modal.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  static const routeName = "/edit-profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _avatarUrl = defaultAvatar;
  String _originalAvatarUrl = defaultAvatar;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _bioController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    // Populate data to text fields
    _avatarUrl = widget.user.avatar;
    _originalAvatarUrl = widget.user.avatar;
    _nameController.text = widget.user.name;
    _usernameController.text = widget.user.username;
    _websiteController.text = widget.user.website ?? "";
    _bioController.text = widget.user.bio ?? "";
    super.initState();
  }

  Future<void> _updateProfile() async {
    if (!_key.currentState!.validate()) return;
    final _provider = Provider.of<ImageUploadProvider>(context, listen: false);

    // Initialize avatar to _avatarUrl if profile photo is not changed
    String _avatar = _avatarUrl;

    // Show loading modal
    showLoadingModal(message: "Updating profile");

    // If file is selected, get image URL from cloud
    if (_provider.imageFile != null) {
      _avatar = await CloudStorage().uploadImagetoCloud(
        file: _provider.imageFile!,
        folder: "users",
      );
    }

    // Final data to be updated
    final _updatedJson = {
      "name": _nameController.text,
      "username": _usernameController.text,
      "website": _websiteController.text,
      "avatar": _avatar,
      "bio": _bioController.text,
    };

    // Update data in Firestore
    await ProfileService().updateProfile(
      updatedProfile: _updatedJson,
      userId: widget.user.id,
    );

    // Close loading modal
    Navigator.pop(context);

    // Redirect to profile screen
    Navigator.pop(context);

    // Clear image file in provider
    _provider.clearImageFile();
  }

  void _setAvatarUrl(String url) {
    setState(() {
      _avatarUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: clearImageUploadProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit profile"),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: _updateProfile,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: spacing * 1.5,
            horizontal: spacing,
          ),
          child: Form(
            key: _key,
            child: Column(
              children: [
                _EditAvatar(
                  avatarUrl: _avatarUrl,
                  originalAvatarUrl: _originalAvatarUrl,
                  setAvatarUrl: _setAvatarUrl,
                ),
                const SizedBox(height: spacing * 2),
                TextFormField(
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Name required";
                    }
                    return null;
                  },
                  decoration: textFieldDecoration.copyWith(
                    labelText: "Name",
                  ),
                ),
                const SizedBox(height: spacing),
                TextFormField(
                  controller: _usernameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Username required";
                    }
                    return null;
                  },
                  decoration: textFieldDecoration.copyWith(
                    labelText: "Username",
                  ),
                ),
                const SizedBox(height: spacing),
                TextFormField(
                  controller: _websiteController,
                  decoration: textFieldDecoration.copyWith(
                    labelText: "Website",
                  ),
                ),
                const SizedBox(height: spacing),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  controller: _bioController,
                  decoration: textFieldDecoration.copyWith(
                    labelText: "Bio",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditAvatar extends StatelessWidget {
  final String avatarUrl, originalAvatarUrl;
  final Function setAvatarUrl;

  const _EditAvatar({
    Key? key,
    required this.avatarUrl,
    required this.originalAvatarUrl,
    required this.setAvatarUrl,
  }) : super(key: key);

  void _showBottomSheet() {
    openBottomSheet(
      child: _BottomSheet(setAvatarUrl: setAvatarUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ImageUploadProvider>(
          builder: (context, _provider, _) {
            if (_provider.imageFile == null) {
              return CachedCircleAvatar(
                imageUrl: avatarUrl,
                scale: 5,
              );
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(10000),
              child: Image.file(
                _provider.imageFile!,
                width: spacing * 5,
                height: spacing * 5,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        const SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                // If current avatar is default avatar, directly select image
                if (avatarUrl == defaultAvatar) {
                  await selectGalleryImage();
                } else {
                  // Show bottom sheet to choose new image or reset to default
                  _showBottomSheet();
                }
              },
              child: Text(
                "Change profile photo",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Consumer<ImageUploadProvider>(
              builder: (context, _provider, _) {
                if (avatarUrl != originalAvatarUrl ||
                    _provider.imageFile != null) {
                  return Padding(
                    padding: const EdgeInsets.only(left: spacing),
                    child: InkWell(
                      onTap: () {
                        // set image file to null in provider
                        _provider.clearImageFile();
                        // Set avatar to the original avatar
                        setAvatarUrl(originalAvatarUrl);
                      },
                      child: const Text("Undo"),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        )
      ],
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    Key? key,
    required this.setAvatarUrl,
  }) : super(key: key);

  final Function setAvatarUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Choose image from gallery"),
          leading: Icon(
            Icons.photo,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: () async {
            // Close bottom sheet
            Navigator.pop(context);

            // Set image file in provider
            await selectGalleryImage();
          },
        ),
        Consumer<ImageUploadProvider>(
          builder: (context, _provider, _) {
            bool _isImageFileNull = _provider.imageFile == null;
            return ListTile(
              title: Text(
                // If file is changed then show undo
                // else reset to default
                _isImageFileNull ? "Reset to default" : "Undo",
              ),
              leading: Icon(
                _isImageFileNull ? Icons.person : Icons.cancel,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                Navigator.pop(context);
                if (_isImageFileNull) {
                  // Set avatar to default avatar
                  setAvatarUrl(defaultAvatar);
                } else {
                  // Remove image file from provider
                  _provider.clearImageFile();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
