import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/authenticated_screens.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final _user = context.watch<User?>();

    if (_user == null) {
      return const LoginScreen();
    }

    return AuthenticatedScreens();
  }
}
