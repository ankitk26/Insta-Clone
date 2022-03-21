import 'package:insta_clone/models/display_user_model.dart';

class CommentModel {
  CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.editedAt,
    required this.userId,
    this.user,
    required this.postId,
  });

  String id;
  String text;
  DateTime createdAt;
  DateTime editedAt;
  String postId;
  DisplayUserModel? user;
  String userId;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["id"],
      text: json["text"],
      postId: json["postId"],
      userId: json['userId'],
      user:
          json['user'] != null ? DisplayUserModel.fromJson(json["user"]) : null,
      createdAt: DateTime.parse(json["createdAt"]),
      editedAt: DateTime.parse(json["editedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "postId": postId,
        "userId": userId,
        "user": user?.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "editedAt": editedAt.toIso8601String(),
      };
}
