import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  static const path = '/profile';

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      showDeleteConfirmationDialog: true,
      showUnlinkConfirmationDialog: true,
      actions: [
        SignedOutAction((context) => context.go('/')),
      ],
      showMFATile: true,
      avatar: const CircleAvatar(
        radius: 60,
        child: Icon(IconlyBroken.profile, size: 60),
      ),
      children: [
        FilledButton(
          onPressed: () {
            if (context.canPop()) return context.pop();
            context.go('/');
          },
          child: const Text('Go Back'),
        ),
      ],
    );
  }
}
