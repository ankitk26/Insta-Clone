import 'package:insta_clone/models/display_user_model.dart';

class PostModel {
  PostModel({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
    this.user,
    required this.likes,
    this.location,
    this.caption,
  });

  String id;
  String imageUrl;
  String? caption;
  DateTime createdAt;
  String? location;
  String userId;
  DisplayUserModel? user;
  List<String> likes;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"],
      imageUrl: json["imageUrl"],
      caption: json["caption"],
      createdAt: DateTime.parse(json["createdAt"]),
      location: json["location"],
      userId: json['userId'],
      user:
          json['user'] != null ? DisplayUserModel.fromJson(json['user']) : null,
      likes: json['likes'] != null
          ? List<String>.from(json["likes"].map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUrl": imageUrl,
        "caption": caption,
        "createdAt": createdAt.toIso8601String(),
        "location": location,
        "userId": userId,
        "user": user?.toJson(),
        "likes": List<dynamic>.from(likes.map((x) => x)),
      };
}
