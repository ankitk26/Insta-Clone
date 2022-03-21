import 'package:flutter/material.dart';
import 'package:insta_clone/services/auth_service.dart';

class NavigationProvider with ChangeNotifier {
  int _index = 0;
  String _userId = AuthService().userId!;

  int get index => _index;
  String get userId => _userId;

  void updateIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  void updateUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }
}
