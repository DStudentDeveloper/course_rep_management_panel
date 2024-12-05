import 'package:course_rep_management_panel/app/app.dart';
import 'package:course_rep_management_panel/bootstrap.dart';
import 'package:course_rep_management_panel/core/singletons/environment.dart';
import 'package:course_rep_management_panel/core/utils/enums/environment_type.dart';

void main() {
  Environment.instance.setEnvironment(EnvironmentType.staging);
  bootstrap(() => const App());
}
