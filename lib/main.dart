import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/image_upload_provider.dart';
import 'package:insta_clone/providers/navigation_provider.dart';
import 'package:insta_clone/providers/register_form_provider.dart';
import 'package:insta_clone/screens/auth_wrapper.dart';
import 'package:insta_clone/screens/authenticated_screens.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/register_screen.dart';
import 'package:insta_clone/screens/register_screen_two.dart';
import 'package:insta_clone/screens/saved_posts_screen.dart';
import 'package:insta_clone/screens/upload_post_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/generate_route.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => RegisterFormProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: themeData,
        home: const AuthWrapper(),
        routes: {
          AuthenticatedScreens.routeName: (context) => AuthenticatedScreens(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          RegisterScreenTwo.routeName: (context) => const RegisterScreenTwo(),
          UploadPostScreen.routeName: (context) => const UploadPostScreen(),
          SavedPostsScreen.routeName: (context) => const SavedPostsScreen(),
        },
        // For dynamic routes
        onGenerateRoute: (settings) => generateRoute(settings),
      ),
    );
  }
}
