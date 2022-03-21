import 'package:flutter/material.dart';
import 'package:insta_clone/providers/navigation_provider.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:provider/provider.dart';

class AuthenticatedScreens extends StatelessWidget {
  AuthenticatedScreens({Key? key}) : super(key: key);

  static const routeName = "/authenticated-screeens";

  final _pages = [
    const FeedScreen(),
    const SearchScreen(),
    ProfileScreen(userId: AuthService().userId ?? ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(spacing * 1.25),
        ),
        child: Consumer<NavigationProvider>(
          builder: (context, _provider, _) => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _provider.index,
            onTap: (int newIndex) {
              _provider.updateIndex(newIndex);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      body: Consumer<NavigationProvider>(
        builder: (context, _provider, _) => _pages[_provider.index],
      ),
    );
  }
}
