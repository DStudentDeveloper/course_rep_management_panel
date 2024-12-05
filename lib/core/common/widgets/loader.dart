import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCube(color: context.theme.colorScheme.primary),
    );
  }
}
