import 'package:flutter/material.dart';
import 'package:insta_clone/utils/constants.dart';

void showLoadingModal({required String message}) {
  showDialog(
    barrierDismissible: true,
    context: navigatorKey.currentContext!,
    builder: (_) {
      return Dialog(
        backgroundColor: const Color(0xff222222),
        child: Padding(
          padding: const EdgeInsets.all(spacing * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: spacing * 2),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    },
  );
}
