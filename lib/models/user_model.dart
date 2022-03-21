import 'package:insta_clone/utils/constants.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.name,
    this.bio,
    this.website,
    required this.followers,
    required this.following,
    required this.savedPosts,
    required this.avatar,
  });

  String id;
  String username;
  String name;
  String? bio;
  String? website;
  List<String> followers;
  List<String> following;
  List<String> savedPosts;
  String avatar;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      name: json["name"],
      bio: json["bio"] ?? "",
      website: json["website"] ?? "",
      followers: json['followers'] == null
          ? []
          : List<String>.from(json["followers"].map((x) => x)),
      following: json["following"] == null
          ? []
          : List<String>.from(json["following"].map((x) => x)),
      savedPosts: json["savedPosts"] == null
          ? []
          : List<String>.from(json["savedPosts"].map((x) => x)),
      avatar: (json["avatar"] == null || json['avatar'].isEmpty)
          ? defaultAvatar
          : json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "bio": bio,
        "website": website,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
        "savedPosts": List<dynamic>.from(savedPosts.map((x) => x)),
        "avatar": avatar,
      };
}
