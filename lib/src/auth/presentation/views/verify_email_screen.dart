import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  static const path = '/verify-email';

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      actions: [
        EmailVerifiedAction(() => context.go('/')),
        AuthCancelledAction((context) async {
          final router = GoRouter.of(context);
          await FirebaseUIAuth.signOut(context: context);
          router.go('/');
        }),
        // authFailed,
      ],
    );
  }
}
