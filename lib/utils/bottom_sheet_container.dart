import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/constants.dart';

void openBottomSheet({required Widget child}) {
  final context = navigatorKey.currentContext!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return Container(
        decoration: const BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(spacing),
            topRight: Radius.circular(spacing),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(spacing * 2),
              ),
              child: Container(
                color: textSecondary,
                width: spacing * 2.5,
                height: spacing / 3,
              ),
            ),
            child
          ],
        ),
      );
    },
  );
}
