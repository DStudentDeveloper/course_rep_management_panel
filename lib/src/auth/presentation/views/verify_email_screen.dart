import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_rep_management_panel/core/utils/typedefs.dart';
import 'package:course_rep_management_panel/src/profile/presentation/views/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        EmailVerifiedAction(() async {
          final router = GoRouter.of(context);
          final user = FirebaseAuth.instance.currentUser!;
          final response = await FirebaseFunctions.instance
              .httpsCallable('makeAdmin')
              .call<DataMap>({'uid': user.uid});
          await FirebaseAuth.instance
              .signInWithCustomToken(response.data['token'] as String);
          if (user.displayName == null) {
            router.go(UserProfileScreen.path);
          } else {
            router.go('/');
          }
        }),
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
