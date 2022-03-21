import 'package:flutter/material.dart';
import 'package:insta_clone/models/comment_model.dart';
import 'package:insta_clone/services/comment_service.dart';
import 'package:insta_clone/widgets/comment_item.dart';

class CommentsList extends StatelessWidget {
  final String postId;
  const CommentsList({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Future<CommentModel>>>(
      stream: CommentService().getPostComments(postId),
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

        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Center(
            child: Text("No comments yet..."),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children:
                data.map((comment) => CommentItem(comment: comment)).toList(),
          ),
        );
      },
    );
  }
}
