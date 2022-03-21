import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/screens/edit_post_screen.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/utils/bottom_sheet_container.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/view_profile.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';

class PostItemHeader extends StatelessWidget {
  const PostItemHeader({
    Key? key,
    required this.post,
    required String? userId,
  })  : _userId = userId,
        super(key: key);

  final PostModel post;
  final String? _userId;

  void _showBottomSheet() {
    final context = navigatorKey.currentContext!;
    openBottomSheet(
      child: Column(
        children: [
          ListTile(
            title: const Text("Edit"),
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                EditPostScreen.routeName,
                arguments: post,
              );
            },
          ),
          ListTile(
            title: const Text("Delete"),
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await PostService().deletePost(post.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedCircleAvatar(
              imageUrl: post.user?.avatar ?? "",
              scale: 2.25,
            ),
            const SizedBox(width: spacing / 1.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => viewProfile(post.userId),
                  child: Text(
                    post.user?.username ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                (post.location != null && post.location!.isNotEmpty)
                    ? Text(
                        post.location ?? "",
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.drag_handle),
          onPressed: () {
            if (post.userId != _userId) return;
            _showBottomSheet();
          },
        )
      ],
    );
  }
}
