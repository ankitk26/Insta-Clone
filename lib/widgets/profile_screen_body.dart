import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/following_screen.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';
import 'package:insta_clone/widgets/follow_or_edit_button.dart';
import 'package:insta_clone/widgets/user_posts_list.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenBody extends StatelessWidget {
  final UserModel user;
  const ProfileScreenBody({Key? key, required this.user}) : super(key: key);

  Future<void> _launchUrl() async {
    if (!await launch(
      user.website!,
      forceSafariVC: false,
      forceWebView: false,
    )) {
      throw "Could not launch ${user.website}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: spacing * 2,
          horizontal: spacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UserAvatarAndNumbers(user: user),
            const SizedBox(height: spacing * 1.5),
            Text(
              user.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (user.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: spacing / 2),
                child: Text(user.bio ?? ""),
              ),
            if (user.website!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: spacing / 2),
                child: InkWell(
                  onTap: _launchUrl,
                  child: Text(
                    user.website ?? "",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: spacing),
            FollowOrEditButton(user: user),
            const SizedBox(height: spacing),
            UserPostsList(userId: user.id),
          ],
        ),
      ),
    );
  }
}

class _UserAvatarAndNumbers extends StatelessWidget {
  const _UserAvatarAndNumbers({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CachedCircleAvatar(
          imageUrl: user.avatar,
          scale: 5,
        ),
        Column(
          children: [
            StreamBuilder<int>(
              stream: PostService().userPostsCount(user.id),
              builder: (context, snapshot) {
                return Text("${snapshot.data ?? 0}");
              },
            ),
            const SizedBox(
              height: spacing / 2,
            ),
            const Text("Posts")
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              FollowingScreen.routeName,
              arguments: FollowingScreenArgs(
                showFollowing: false,
                user: user,
              ),
            );
          },
          child: Column(
            children: [
              Text("${user.followers.length}"),
              const SizedBox(
                height: spacing / 2,
              ),
              const Text("Followers")
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              FollowingScreen.routeName,
              arguments: FollowingScreenArgs(
                showFollowing: true,
                user: user,
              ),
            );
          },
          child: Column(
            children: [
              Text("${user.following.length}"),
              const SizedBox(
                height: spacing / 2,
              ),
              const Text("Following")
            ],
          ),
        ),
      ],
    );
  }
}
