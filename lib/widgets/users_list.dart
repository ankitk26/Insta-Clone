import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/view_profile.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';
import 'package:insta_clone/widgets/follow_or_edit_button.dart';

class UsersList extends StatelessWidget {
  final List<String> users;
  final bool isFollowing;
  const UsersList({
    Key? key,
    required this.users,
    required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Text(isFollowing ? "No users in following" : "No followers"),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacing),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, i) {
          return StreamBuilder<UserModel>(
            stream: ProfileService().getProfile(users[i]),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) return const SizedBox();
              return ListTile(
                onTap: () => viewProfile(user.id),
                leading: CachedCircleAvatar(
                  imageUrl: user.avatar,
                  scale: 2.5,
                ),
                title: Text(user.username),
                subtitle: Text(user.name),
                trailing: user.id != AuthService().userId
                    ? FollowOrEditButton(user: user)
                    : const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}
