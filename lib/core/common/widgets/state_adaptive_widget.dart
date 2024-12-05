import 'package:course_rep_management_panel/core/common/widgets/loader.dart';
import 'package:flutter/material.dart';

class StateAdaptiveWidget extends StatelessWidget {
  const StateAdaptiveWidget({
    required this.child,
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Loader();

    return child;
  }
}
