import 'package:flutter/material.dart';
import 'package:insta_clone/screens/authenticated_screens.dart';
import 'package:insta_clone/screens/register_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    if (_key.currentState!.validate()) {
      final result = await AuthService().login(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );
      if (result == "ok") {
        Navigator.pushReplacementNamed(context, AuthenticatedScreens.routeName);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _togglePassword() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing * 1.25),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "InstaClone",
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    fontFamily: "InstaFont",
                                  ),
                        ),
                      ),
                      const SizedBox(height: spacing * 2),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Email required";
                          }
                          return null;
                        },
                        cursorColor: textSecondary,
                        decoration: authTextFieldDecoration.copyWith(
                          hintText: "Email address",
                        ),
                      ),
                      const SizedBox(height: spacing),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        cursorColor: textSecondary,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Password required";
                          }
                          return null;
                        },
                        decoration: authTextFieldDecoration.copyWith(
                          hintText: "Password",
                          contentPadding: const EdgeInsets.all(spacing),
                          suffixIcon: GestureDetector(
                            onTap: _togglePassword,
                            child: _isPasswordVisible
                                ? Icon(
                                    Icons.visibility,
                                    color: textSecondary,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: textSecondary,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: spacing),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing),
                          child: Text("Login"),
                        ),
                      ),
                      const SizedBox(height: spacing),
                      Center(
                        child: Text(
                          "Forgot password?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: spacing / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
