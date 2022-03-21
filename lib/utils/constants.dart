import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';

const double spacing = 15;
final navigatorKey = GlobalKey<NavigatorState>();
const String defaultAvatar =
    "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y";

final authTextFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(
    horizontal: spacing,
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  filled: true,
  hintStyle: TextStyle(
    color: textSecondary,
    fontWeight: FontWeight.w400,
  ),
  fillColor: surfaceColor,
);

final textFieldDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: textSecondary!,
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: textSecondary!,
    ),
  ),
  labelStyle: TextStyle(
    color: textSecondary,
  ),
  hintStyle: TextStyle(
    color: textSecondary,
    fontWeight: FontWeight.w400,
  ),
);

final themeData = ThemeData().copyWith(
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: surfaceColor,
    elevation: 0.2,
    behavior: SnackBarBehavior.floating,
  ),
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    elevation: 0.2,
    backgroundColor: surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(spacing * 1.25),
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    elevation: 0.2,
    showSelectedLabels: false,
    unselectedItemColor: textSecondary,
    showUnselectedLabels: false,
    selectedItemColor: textPrimary,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(
          width: 1,
          color: textSecondary!,
        ),
      ),
    ),
  ),
  textTheme: const TextTheme().copyWith(
    titleMedium: TextStyle(
      fontSize: 15,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      color: textPrimary,
    ),
    bodySmall: TextStyle(
      color: textSecondary,
    ),
  ),
  dividerColor: Colors.grey[600],
  iconTheme: IconThemeData(
    color: textPrimary,
    size: 24,
  ),
);
