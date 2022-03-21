class DisplayUserModel {
  DisplayUserModel({
    required this.username,
    required this.avatar,
  });

  String username;
  String avatar;

  factory DisplayUserModel.fromJson(Map<String, dynamic> json) {
    return DisplayUserModel(
      username: json["username"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "avatar": avatar,
      };
}
