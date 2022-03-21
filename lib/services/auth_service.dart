import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/cloud_storage.dart';
import 'package:insta_clone/services/profile_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();
  String? get userId => _auth.currentUser?.uid;

  Future<UserModel> get currentUser {
    return ProfileService().getRealtimeUser(userId!);
  }

  // * Login a user
  Future<String> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "ok";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // * Register a user
  Future<String> register({
    required String email,
    required String password,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final imageFile = profileData['avatar'];
      String avatar = "";
      if (profileData['avatar'] != null) {
        avatar = await CloudStorage().uploadImagetoCloud(
          file: imageFile,
          folder: "users",
        );
      }
      // Create profile collection in firestore
      await ProfileService().createProfile({
        "id": user.user?.uid,
        ...profileData,
        "avatar": avatar,
      });
      return "ok";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // * Logout the user
  Future<String> logout() async {
    try {
      await _auth.signOut();
      return "ok";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
