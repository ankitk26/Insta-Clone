import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/auth_service.dart';

class ProfileService {
  final _profileCollection = FirebaseFirestore.instance.collection("profiles");

  // * Get User profile as Stream
  Stream<UserModel> getProfile(String userId) async* {
    yield* _profileCollection.doc(userId).snapshots().map((snapshot) {
      return UserModel.fromJson({"id": snapshot.id, ...?snapshot.data()});
    });
  }

  // * Get User profile as Future
  Future<UserModel> getRealtimeUser(String userId) async {
    return getProfile(userId).first;
  }

  Stream<List<UserModel>> get allUsers {
    return _profileCollection
        .where("id", isNotEqualTo: AuthService().userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson({
          ...doc.data(),
          "id": doc.id,
        });
      }).toList();
    });
  }

  // * Create user's profile after registering
  Future<void> createProfile(Map<String, dynamic> profileData) async {
    try {
      final model = UserModel.fromJson(profileData);
      await _profileCollection.doc(profileData['id']).set(model.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  // * Update user's profile
  Future<void> updateProfile({
    required Map<String, dynamic> updatedProfile,
    required String userId,
  }) async {
    try {
      await _profileCollection.doc(userId).update(updatedProfile);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  Future<void> followUser(String userId) async {
    final currentUserId = AuthService().userId;

    await _profileCollection.doc(userId).update({
      "followers": FieldValue.arrayUnion([currentUserId]),
    });

    await _profileCollection.doc(currentUserId).update({
      "following": FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unfollowUser(String userId) async {
    final currentUserId = AuthService().userId;

    await _profileCollection.doc(userId).update({
      "followers": FieldValue.arrayRemove([currentUserId]),
    });

    await _profileCollection.doc(currentUserId).update({
      "following": FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> handleBookmark(String postId) async {
    final currentUser =
        await ProfileService().getRealtimeUser(AuthService().userId!);
    if (currentUser.savedPosts.contains(postId)) {
      await _profileCollection.doc(currentUser.id).update({
        "savedPosts": FieldValue.arrayRemove([postId])
      });
    } else {
      await _profileCollection.doc(currentUser.id).update({
        "savedPosts": FieldValue.arrayUnion([postId])
      });
    }
  }
}
