import 'dart:developer';

import 'package:course_rep_management_panel/core/errors/exceptions.dart';
import 'package:course_rep_management_panel/core/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class NetworkUtils {
  const NetworkUtils();

  static Future<void> authorizeUser(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user == null) {
      log(
        'Error occurred: Unauthorized user access',
        level: 1000,
        stackTrace: StackTrace.current,
      );
      throw const ServerException(
        message: 'Unauthorized user access',
        statusCode: 'UnauthorizedError',
      );
    }
  }

  static T handleRemoteSourceException<T>(
    Object e, {
    required String repositoryName,
    required String methodName,
    String? errorMessage,
    String? statusCode,
    StackTrace? stackTrace,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: e,
      stackTrace: stackTrace ?? StackTrace.current,
      level: 1200,
    );
    throw ServerException(
      message: errorMessage ?? 'Something went wrong',
      statusCode: statusCode ?? '${methodName.snakeCase.toUpperCase()}UNKNOWN',
    );
  }
}
