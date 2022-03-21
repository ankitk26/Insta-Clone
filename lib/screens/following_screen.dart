import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/users_list.dart';

class FollowingScreenArgs {
  bool showFollowing;
  UserModel user;

  FollowingScreenArgs({required this.showFollowing, required this.user});
}

class FollowingScreen extends StatelessWidget {
  final bool showFollowing;
  final UserModel user;

  const FollowingScreen({
    Key? key,
    required this.showFollowing,
    required this.user,
  }) : super(key: key);

  static const routeName = '/following';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: showFollowing ? 1 : 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          bottom: TabBar(
            indicatorColor: textSecondary,
            tabs: [
              Tab(text: "${user.followers.length} followers"),
              Tab(text: "${user.following.length} following"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UsersList(users: user.followers, isFollowing: false),
            UsersList(users: user.following, isFollowing: true),
          ],
        ),
      ),
    );
  }
}
