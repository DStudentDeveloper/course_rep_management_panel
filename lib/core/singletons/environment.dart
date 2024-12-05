import 'package:course_rep_management_panel/core/utils/enums/environment_type.dart';

class Environment {
  Environment._internal();

  static final Environment instance = Environment._internal();

  EnvironmentType _current = EnvironmentType.development;

  EnvironmentType get current => _current;

  void setEnvironment(EnvironmentType environmentType) {
    if (_current != environmentType) _current = environmentType;
  }
}
