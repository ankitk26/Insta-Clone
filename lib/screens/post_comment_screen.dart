import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/format_date.dart';
import 'package:insta_clone/utils/view_profile.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';
import 'package:insta_clone/widgets/comments_list.dart';
import 'package:insta_clone/widgets/post_comment_input.dart';

class PostCommentScreen extends StatelessWidget {
  final PostModel post;
  const PostCommentScreen({Key? key, required this.post}) : super(key: key);

  static const routeName = "/post-comment";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Comments"),
      ),
      bottomSheet: PostCommentInput(postId: post.id),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostCaption(post: post),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(spacing).copyWith(
                bottom: spacing * 5,
              ),
              child: CommentsList(postId: post.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCaption extends StatelessWidget {
  const _PostCaption({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedCircleAvatar(
            imageUrl: post.user?.avatar ?? defaultAvatar,
            scale: 2.25,
          ),
          const SizedBox(width: spacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => viewProfile(post.userId),
                  child: Text(
                    post.user?.username ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: spacing / 4),
                if (post.caption != null && post.caption!.isNotEmpty)
                  Text(
                    post.caption!,
                  ),
                const SizedBox(height: spacing),
                Text(
                  formatDateTime(post.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
