import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/screens/single_post_screen.dart';
import 'package:insta_clone/utils/colors.dart';

class PostGridItem extends StatelessWidget {
  final PostModel post;
  const PostGridItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          SinglePostScreen.routeName,
          arguments: post.id,
        );
      },
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          color: surfaceColor,
        ),
        imageUrl: post.imageUrl,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}
