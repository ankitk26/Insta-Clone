import 'package:flutter/material.dart';
import 'package:insta_clone/models/comment_model.dart';
import 'package:insta_clone/screens/edit_comment_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/comment_service.dart';
import 'package:insta_clone/utils/bottom_sheet_container.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/view_profile.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';

class CommentItem extends StatelessWidget {
  final Future<CommentModel> comment;
  const CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CommentModel>(
      future: comment,
      builder: (context, snapshot) {
        final comment = snapshot.data;

        if (comment == null) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: spacing * 1.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedCircleAvatar(
                imageUrl: comment.user?.avatar ?? defaultAvatar,
                scale: 2,
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => viewProfile(comment.userId),
                          child: Text(
                            comment.user?.username ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (comment.createdAt != comment.editedAt)
                          Text(
                            " (Edited)",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: spacing / 4),
                    Text(
                      comment.text,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacing / 2),
              if (comment.userId == AuthService().userId)
                _EditCommentBtn(comment: comment),
            ],
          ),
        );
      },
    );
  }
}

class _EditCommentBtn extends StatelessWidget {
  final CommentModel comment;
  const _EditCommentBtn({Key? key, required this.comment}) : super(key: key);

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
                EditCommentScreen.routeName,
                arguments: comment,
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
              await CommentService().deleteComment(comment.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert, size: 14),
      onPressed: _showBottomSheet,
    );
  }
}
