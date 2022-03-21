import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/screens/upload_post_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/post_service.dart';
import 'package:insta_clone/widgets/future_post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "InstaClone",
          style: Theme.of(context).textTheme.headline5?.copyWith(
                fontFamily: "InstaFont",
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.camera_alt_outlined,
          ),
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(
              AssetImage("assets/icons/add_icon.png"),
              size: 20,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                UploadPostScreen.routeName,
              );
            },
          ),
        ],
      ),
      body: const _FeedList(),
    );
  }
}

class _FeedList extends StatelessWidget {
  const _FeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Future<PostModel>>>(
      stream: PostService().feed(AuthService().currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          // User has no following list
          if (snapshot.error.toString().contains("non-empty")) {
            return const Center(
              child: Text("Nothing to show"),
            );
          }
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Center(
            child: Text("Nothing to show"),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: data.map((post) {
              return FuturePost(post: post);
            }).toList(),
          ),
        );
      },
    );
  }
}
