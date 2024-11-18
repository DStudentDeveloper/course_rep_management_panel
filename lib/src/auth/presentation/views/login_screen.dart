import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/src/auth/presentation/views/sign_up_screen.dart';
import 'package:course_rep_management_panel/src/auth/presentation/views/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({this.auth, super.key});

  static const path = '/login';

  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      auth: auth,
      showPasswordVisibilityToggle: true,
      showAuthActionSwitch: false,
      subtitleBuilder: (_, __) {
        return RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: context.theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: 'Register',
                style: context.theme.textTheme.labelLarge?.copyWith(
                  color: context.theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => context.go(SignUpScreen.path),
              ),
            ],
          ),
        );
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          if (!state.user!.emailVerified) {
            context.go(VerifyEmailScreen.path);
          } else {
            context.go('/');
          }
        }), // authFailed,
      ],
    );
  }
}
