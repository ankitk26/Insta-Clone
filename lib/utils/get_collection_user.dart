import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/user_model_to_display_user_json.dart';

Future<Map<String, dynamic>> getDisplayUser(String userId) async {
  final postUser = await ProfileService().getRealtimeUser(userId);
  return userModelToDisplayUserJson(postUser);
}
