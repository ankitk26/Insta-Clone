import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/widgets/future_post.dart';

class SinglePostScreen extends StatelessWidget {
  final String postId;
  const SinglePostScreen({Key? key, required this.postId}) : super(key: key);

  static const routeName = '/single-post';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: spacing,
          ),
          child: StreamBuilder<Future<PostModel>>(
            stream: PostService().getSinglePost(postId),
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              return FuturePost(post: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}
