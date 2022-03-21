import 'package:flutter/material.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/providers/register_form_provider.dart';
import 'package:insta_clone/screens/auth_wrapper.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/select_gallery_image.dart';
import 'package:insta_clone/utils/show_loading_modal.dart';
import 'package:provider/provider.dart';

class RegisterScreenTwo extends StatefulWidget {
  const RegisterScreenTwo({Key? key}) : super(key: key);

  static const routeName = "/register-screen-two";

  @override
  State<RegisterScreenTwo> createState() => _RegisterScreenTwoState();
}

class _RegisterScreenTwoState extends State<RegisterScreenTwo> {
  final _key = GlobalKey<FormState>();

  Future<void> _handleRegister() async {
    if (_key.currentState!.validate()) {
      final _registerFormProvider = Provider.of<RegisterFormProvider>(
        context,
        listen: false,
      );
      final _imageUploadProvider = Provider.of<ImageUploadProvider>(
        context,
        listen: false,
      );

      showLoadingModal(message: "Signing-up");

      final result = await AuthService().register(
        email: _registerFormProvider.emailController.text,
        password: _registerFormProvider.passwordController.text,
        profileData: {
          "name": _registerFormProvider.nameController.text,
          "username": _registerFormProvider.usernameController.text,
          "avatar": _imageUploadProvider.imageFile
        },
      );

      // Close loading modal
      Navigator.of(context).pop();

      if (result != "ok") {
        // Redirect to email field
        FocusScope.of(context).unfocus();
        _registerFormProvider.setEmailError(result);
        Navigator.pop(context);
      } else {
        // Clean-up data
        _registerFormProvider.clearFields();
        _imageUploadProvider.clearImageFile();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, AuthWrapper.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacing * 1.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<ImageUploadProvider>(builder: (context, _provider, _) {
                  if (_provider.imageFile != null) {
                    return CircleAvatar(
                      maxRadius: spacing * 3,
                      backgroundColor: Colors.transparent,
                      backgroundImage: FileImage(_provider.imageFile!),
                    );
                  }
                  return const CircleAvatar(
                    maxRadius: spacing * 3,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(defaultAvatar),
                  );
                }),
                const SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: selectGalleryImage,
                      child: Text(
                        "Choose avatar",
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    Consumer<ImageUploadProvider>(
                      builder: (context, _provider, _) {
                        if (_provider.imageFile != null) {
                          return Padding(
                            padding: const EdgeInsets.only(left: spacing),
                            child: InkWell(
                              onTap: () => _provider.clearImageFile(),
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                  color: textSecondary,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: spacing * 2),
            Form(
              key: _key,
              child: Consumer<RegisterFormProvider>(
                builder: (context, _provider, _) => TextFormField(
                  controller: _provider.nameController,
                  decoration: authTextFieldDecoration.copyWith(
                    hintText: "Name",
                  ),
                ),
              ),
            ),
            const SizedBox(height: spacing * 2),
            ElevatedButton.icon(
              onPressed: _handleRegister,
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: spacing),
                child: Text("Complete sign up"),
              ),
              icon: const Icon(Icons.done),
            ),
          ],
        ),
      ),
    );
  }
}
