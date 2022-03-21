import 'package:insta_clone/models/display_user_model.dart';
import 'package:insta_clone/models/user_model.dart';

Map<String, dynamic> userModelToDisplayUserJson(UserModel user) {
  return DisplayUserModel.fromJson(user.toJson()).toJson();
}
