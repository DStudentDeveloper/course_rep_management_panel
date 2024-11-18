part of 'router.dart';

const authRoutes = [
  LoginScreen.path,
  SignUpScreen.path,
  VerifyEmailScreen.path,
];

final router = GoRouter(
  redirect: (_, state) async {
    if (authRoutes.contains(state.fullPath)) return null;

    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      user = await FirebaseAuth.instance.authStateChanges().first;
      if (user == null || user.displayName == null) {
        return LoginScreen.path;
      }
    } else if (!user.emailVerified) {
      return VerifyEmailScreen.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) {
        return const Scaffold(
          body: Center(
            child: Text('Home'),
          ),
        );
      },
    ),
    GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
    GoRoute(path: SignUpScreen.path, builder: (_, __) => const SignUpScreen()),
    GoRoute(
      path: VerifyEmailScreen.path,
      builder: (_, __) => const VerifyEmailScreen(),
    ),
  ],
);
