import 'package:course_rep_management_panel/src/auth/presentation/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  FirebaseApp get app => MockFirebaseApp();
}

void main() {
  setUpAll(() => setFirebaseUiIsTestMode(true));

  group('App', () {
    testWidgets('renders LoginScreen', (tester) async {
      await tester.pumpApp(LoginScreen(auth: MockFirebaseAuth()));
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
