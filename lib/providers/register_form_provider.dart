import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _emailError;

  TextEditingController get emailController => _emailController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;
  String? get emailError => _emailError;

  void setEmailError(String? errorMessage) {
    _emailError = errorMessage;
    notifyListeners();
  }

  void clearFields() {
    _emailController.clear();
    _usernameController.clear();
    _nameController.clear();
    _passwordController.clear();
    setEmailError(null);
    notifyListeners();
  }
}
