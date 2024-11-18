import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/src/auth/presentation/views/login_screen.dart';
import 'package:course_rep_management_panel/src/auth/presentation/views/verify_email_screen.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const path = '/register';

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      showPasswordVisibilityToggle: true,
      showAuthActionSwitch: false,
      subtitleBuilder: (_, __) {
        return RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: context.theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: 'Sign in',
                style: context.theme.textTheme.labelLarge?.copyWith(
                  color: context.theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => context.go(LoginScreen.path),
              ),
            ],
          ),
        );
      },
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) async {
          if (!state.credential.user!.emailVerified) {
            context.go(VerifyEmailScreen.path);
          } else {
            context.go('/');
          }
        }),
        // authFailed,
      ],
    );
  }
}
