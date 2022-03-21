import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/widgets/post_grid_item.dart';
import 'package:masonry_grid/masonry_grid.dart';

class UserPostsList extends StatelessWidget {
  final String userId;
  const UserPostsList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Future<PostModel>>>(
      stream: PostService().userPosts(userId),
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
            child: Text("No posts"),
          );
        }

        return MasonryGrid(
          column: 3,
          children: data
              .map(
                (post) => FutureBuilder<PostModel>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return const SizedBox();
                    return PostGridItem(post: snapshot.data!);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
