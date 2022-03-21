import 'package:flutter/material.dart';
import 'package:insta_clone/models/comment_model.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/edit_comment_screen.dart';
import 'package:insta_clone/screens/edit_post_screen.dart';
import 'package:insta_clone/screens/edit_profile_screen.dart';
import 'package:insta_clone/screens/following_screen.dart';
import 'package:insta_clone/screens/post_comment_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/single_post_screen.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  if (settings.name == PostCommentScreen.routeName) {
    final args = settings.arguments as PostModel;
    return MaterialPageRoute(
      builder: (context) => PostCommentScreen(post: args),
    );
  }

  if (settings.name == SinglePostScreen.routeName) {
    final postId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => SinglePostScreen(postId: postId),
    );
  }

  if (settings.name == ProfileScreen.routeName) {
    final userId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => ProfileScreen(userId: userId),
    );
  }

  if (settings.name == EditProfileScreen.routeName) {
    final args = settings.arguments as UserModel;
    return MaterialPageRoute(
      builder: (context) => EditProfileScreen(user: args),
    );
  }

  if (settings.name == EditPostScreen.routeName) {
    final args = settings.arguments as PostModel;
    return MaterialPageRoute(
      builder: (context) => EditPostScreen(post: args),
    );
  }

  if (settings.name == FollowingScreen.routeName) {
    final args = settings.arguments as FollowingScreenArgs;
    return MaterialPageRoute(
      builder: (context) => FollowingScreen(
        showFollowing: args.showFollowing,
        user: args.user,
      ),
    );
  }

  if (settings.name == EditCommentScreen.routeName) {
    final args = settings.arguments as CommentModel;
    return MaterialPageRoute(
      builder: (context) => EditCommentScreen(
        comment: args,
      ),
    );
  }

  return null;
}
