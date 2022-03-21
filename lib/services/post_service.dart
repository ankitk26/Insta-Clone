import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/get_collection_user.dart';

class PostService {
  final _postsCollection = FirebaseFirestore.instance.collection("posts");

  // Get feed in home screen
  Stream<List<Future<PostModel>>> feed(Future<UserModel> user) async* {
    final _user = await user;
    yield* _postsCollection
        .where("userId", whereIn: _user.following)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) async => PostModel.fromJson({
                  ...doc.data(),
                  "id": doc.id,
                  "user": await getDisplayUser(doc.data()['userId'])
                }))
            .toList());
  }

  // Get user's profile posts
  Stream<List<Future<PostModel>>> userPosts(String userId) {
    return _postsCollection
        .where("userId", isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) async {
        return PostModel.fromJson({
          ...doc.data(),
          "id": doc.id,
          "user": await getDisplayUser(doc.data()['userId']),
        });
      }).toList();
    });
  }

  Stream<int> userPostsCount(String userId) {
    return _postsCollection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Upload a new post
  Future<void> newPost(Map<String, dynamic> postInput) async {
    try {
      // int randomInt = Random().nextInt(200) + 1;
      final postJson = {
        ...postInput,
        "createdAt": DateTime.now().toIso8601String(),
      };
      await _postsCollection.add(postJson);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  // Get a single post
  Stream<Future<PostModel>> getSinglePost(String postId) async* {
    yield* _postsCollection.doc(postId).snapshots().map((doc) async {
      return PostModel.fromJson({
        ...?doc.data(),
        "id": doc.id,
        "user": await getDisplayUser(doc['userId'])
      });
    });
  }

  // Like a post
  Future<void> likePost({required PostModel post}) async {
    try {
      final userId = AuthService().userId;
      if (post.likes.contains(userId)) {
        await _postsCollection.doc(post.id).update({
          "likes": FieldValue.arrayRemove([userId]),
        });
      } else {
        await _postsCollection.doc(post.id).update({
          "likes": FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<String>> userSavedPosts() async {
    final currentUser =
        await ProfileService().getRealtimeUser(AuthService().userId!);

    return currentUser.savedPosts;
  }

  Future<void> deletePost(String postId) async {
    await _postsCollection.doc(postId).delete();
  }

  Future<void> updatePost({
    required Map<String, dynamic> updatedPostJson,
    required String postId,
  }) async {
    await _postsCollection.doc(postId).update(updatedPostJson);
  }
}
