import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/format_date.dart';
import 'package:insta_clone/widgets/post_item_buttons.dart';
import 'package:insta_clone/widgets/post_item_header.dart';

class PostItem extends StatelessWidget {
  final PostModel post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  Future<void> _likePost(PostModel post) async {
    await PostService().likePost(post: post);
  }

  @override
  Widget build(BuildContext context) {
    final _userId = AuthService().userId;
    final _isPostLikedByUser = post.likes.contains(AuthService().userId);

    return StreamBuilder<UserModel>(
      stream: ProfileService().getProfile(_userId!),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostItemHeader(post: post, userId: _userId),
              const SizedBox(height: spacing / 2),
              GestureDetector(
                onDoubleTap: () {
                  _likePost(post);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(spacing),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: surfaceColor,
                    ),
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                ),
              ),
              PostItemButtons(post: post, user: snapshot.data!),
              Text(
                "${post.likes.length} likes",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (post.caption != null && post.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: spacing,
                  ),
                  child: Text(post.caption!),
                ),
              Padding(
                padding: const EdgeInsets.only(top: spacing),
                child: Text(
                  formatDateTime(post.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
