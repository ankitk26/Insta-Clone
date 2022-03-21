import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/models/comment_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/utils/get_collection_user.dart';

class CommentService {
  final _commentsCollection = FirebaseFirestore.instance.collection("comments");

  Stream<List<Future<CommentModel>>> getPostComments(String postId) {
    return _commentsCollection
        .where("postId", isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) async {
              return CommentModel.fromJson({
                ...doc.data(),
                "id": doc.id,
                "user": await getDisplayUser(doc.data()['userId']),
              });
            }).toList());
  }

  Future<void> addComment(String text, String postId) async {
    final userId = AuthService().userId;

    try {
      final currentDateTime = DateTime.now().toIso8601String();
      await _commentsCollection.add({
        "userId": userId,
        "postId": postId,
        "text": text,
        "createdAt": currentDateTime,
        "editedAt": currentDateTime,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _commentsCollection.doc(commentId).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updateComment({
    required String commentId,
    required String text,
  }) async {
    try {
      await _commentsCollection.doc(commentId).update({
        "text": text,
        "editedAt": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
