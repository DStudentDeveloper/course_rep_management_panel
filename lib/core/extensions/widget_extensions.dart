import 'package:course_rep_management_panel/core/common/widgets/state_adaptive_widget.dart';
import 'package:flutter/widgets.dart';

extension WidgetExtensions on Widget {
  // ignore: avoid_positional_boolean_parameters
  Widget loading(bool isLoading) =>
      StateAdaptiveWidget(isLoading: isLoading, child: this);
}
