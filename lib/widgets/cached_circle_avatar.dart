import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';

class CachedCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double scale;
  const CachedCircleAvatar(
      {Key? key, required this.imageUrl, required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10000),
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          color: surfaceColor,
        ),
        width: spacing * scale,
        height: spacing * scale,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
