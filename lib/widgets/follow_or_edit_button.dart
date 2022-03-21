import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/edit_profile_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/constants.dart';

class FollowOrEditButton extends StatelessWidget {
  final UserModel user;
  const FollowOrEditButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If user visits their own profile
    if (user.id == AuthService().userId) {
      return SizedBox(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              EditProfileScreen.routeName,
              arguments: user,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing),
            child: Text(
              "Edit profile",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      );
    }

    // Logged user follows profile user
    if (user.followers.contains(AuthService().userId)) {
      return SizedBox(
        child: TextButton(
          onPressed: () async {
            await ProfileService().unfollowUser(user.id);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing),
            child: Text(
              "Unfollow",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          await ProfileService().followUser(user.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing),
          child: Text(
            "Follow",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
