import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/providers/navigation_provider.dart';
import 'package:insta_clone/screens/auth_wrapper.dart';
import 'package:insta_clone/screens/saved_posts_screen.dart';
import 'package:insta_clone/screens/upload_post_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/bottom_sheet_container.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/widgets/profile_screen_body.dart';
import 'package:provider/provider.dart';

class ProfileScreenArgs {
  String userId;
  ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  static const routeName = "/profile";

  void _showBottomSheet() {
    final context = navigatorKey.currentContext!;
    openBottomSheet(
      child: Column(
        children: [
          ListTile(
            title: const Text("Saved"),
            leading: Icon(
              Icons.bookmark_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                SavedPostsScreen.routeName,
              );
            },
          ),
          ListTile(
            title: const Text("Logout"),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () async {
              Navigator.pop(context);
              await AuthService().logout();
              Navigator.pushReplacementNamed(
                context,
                AuthWrapper.routeName,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<NavigationProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          _provider.updateIndex(0);
        }
        return false;
      },
      child: StreamBuilder<UserModel>(
        stream: ProfileService().getProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(
              child: Text("Nothing to show"),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(user.username),
              actions: [
                if (user.id == AuthService().userId)
                  IconButton(
                    icon: const ImageIcon(
                      AssetImage("assets/icons/add_icon.png"),
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        UploadPostScreen.routeName,
                      );
                    },
                  ),
                if (user.id == AuthService().userId)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: _showBottomSheet,
                  )
              ],
            ),
            body: ProfileScreenBody(user: user),
          );
        },
      ),
    );
  }
}
