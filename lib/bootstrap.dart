import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:course_rep_management_panel/core/services/injection_container.dart';
import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/singletons/environment.dart';
import 'package:course_rep_management_panel/core/utils/enums/environment_type.dart';
import 'package:course_rep_management_panel/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    log(details.stack.toString());
  };
  Bloc.observer = const AppBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (Environment.instance.current == EnvironmentType.development) {
    log('Setting up Firebase Emulators', name: 'bootstrap');
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
    await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    log(
      FirebaseAuth.instance.currentUser?.toString() ?? 'No user logged in',
      name: 'bootstrap',
    );
    FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
  }
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  usePathUrlStrategy();
  await init();
  runApp(
    Provider(
      create: (_) => FToast().init(rootNavigatorKey.currentContext!),
      child: await builder(),
    ),
  );
}
