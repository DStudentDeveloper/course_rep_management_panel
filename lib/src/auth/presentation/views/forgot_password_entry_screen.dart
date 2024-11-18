import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordEntryScreen extends StatelessWidget {
  const ForgotPasswordEntryScreen({super.key});

  static const path = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => context.go('/'),
      child: const ForgotPasswordScreen(),
    );
  }
}
