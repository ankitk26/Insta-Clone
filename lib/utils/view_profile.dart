import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/constants.dart';

void viewProfile(String userId) {
  final context = navigatorKey.currentContext!;
  Navigator.pushNamed(
    context,
    ProfileScreen.routeName,
    arguments: userId,
  );
}
