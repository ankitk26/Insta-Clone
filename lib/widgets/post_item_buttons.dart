import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/post_comment_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/constants.dart';

class PostItemButtons extends StatelessWidget {
  final PostModel post;
  final UserModel user;
  const PostItemButtons({Key? key, required this.post, required this.user})
      : super(key: key);

  Future<void> _likePost(PostModel post) async {
    await PostService().likePost(post: post);
  }

  @override
  Widget build(BuildContext context) {
    final isPostLikedByUser = post.likes.contains(AuthService().userId);
    final isPostBookmarked = user.savedPosts.contains(post.id);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Like button
              InkWell(
                child: isPostLikedByUser
                    ? Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.pink[700],
                      )
                    : const Icon(CupertinoIcons.heart),
                onTap: () => _likePost(post),
              ),
              const SizedBox(width: spacing),
              InkWell(
                child: const Icon(CupertinoIcons.chat_bubble),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PostCommentScreen.routeName,
                    arguments: post,
                  );
                },
              ),
              const SizedBox(width: spacing),
              InkWell(
                child: const Icon(Icons.send),
                onTap: () {},
              ),
            ],
          ),

          // Bookmark button
          InkWell(
            child: isPostBookmarked
                ? const Icon(Icons.bookmark)
                : const Icon(Icons.bookmark_outline),
            onTap: () async {
              await ProfileService().handleBookmark(post.id);
            },
          )
        ],
      ),
    );
  }
}
