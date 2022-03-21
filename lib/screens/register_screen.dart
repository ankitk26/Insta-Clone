import 'package:flutter/material.dart';
import 'package:insta_clone/providers/register_form_provider.dart';
import 'package:insta_clone/screens/register_screen_two.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  void _togglePassword() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _continueRegister() {
    if (_key.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        RegisterScreenTwo.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing * 1.25),
                child: Consumer<RegisterFormProvider>(
                  builder: (context, _provider, _) => Form(
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
                          controller: _provider.emailController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email required";
                            }
                            return null;
                          },
                          decoration: authTextFieldDecoration.copyWith(
                            hintText: "Email address",
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            errorText: _provider.emailError,
                          ),
                        ),
                        const SizedBox(height: spacing),
                        TextFormField(
                          controller: _provider.usernameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Username required";
                            }
                            return null;
                          },
                          decoration: authTextFieldDecoration.copyWith(
                            hintText: "Username",
                          ),
                        ),
                        const SizedBox(height: spacing),
                        TextFormField(
                          controller: _provider.passwordController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Password required";
                            }
                            if (val.length < 6) {
                              return "Minimum 6 characters required";
                            }
                            return null;
                          },
                          decoration: authTextFieldDecoration.copyWith(
                            hintText: "Password",
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
                          onPressed: _continueRegister,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: spacing),
                            child: Text("Continue"),
                          ),
                        ),
                      ],
                    ),
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
                  "Already have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Log in",
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
