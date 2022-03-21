import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/widgets/post_grid_item.dart';
import 'package:masonry_grid/masonry_grid.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  static const routeName = "/saved-posts";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Posts"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: spacing * 2),
          child: StreamBuilder<UserModel>(
            stream: ProfileService().getProfile(AuthService().userId!),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const SizedBox();
              }

              if (snapshot.data!.savedPosts.isEmpty) {
                return const Center(
                  child: Text("No posts saved"),
                );
              }

              return MasonryGrid(
                column: 3,
                children: snapshot.data!.savedPosts.map((postId) {
                  return StreamBuilder<Future<PostModel>>(
                    stream: PostService().getSinglePost(postId),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const SizedBox();
                      }

                      return FutureBuilder<PostModel>(
                        future: snapshot.data,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) return const SizedBox();
                          return PostGridItem(post: snapshot.data!);
                        },
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
