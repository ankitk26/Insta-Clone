import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/widgets/post_item.dart';

class FuturePost extends StatelessWidget {
  final Future<PostModel> post;
  const FuturePost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostModel>(
      future: post,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox();
        }

        return PostItem(
          post: snapshot.data!,
        );
      },
    );
  }
}
