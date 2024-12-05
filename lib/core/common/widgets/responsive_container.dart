import 'package:course_rep_management_panel/core/utils/enums/breakpoint.dart';
import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({required this.child, super.key})
      : breakPoint = BreakPoint.xs;

  const ResponsiveContainer.sm({required this.child, super.key})
      : breakPoint = BreakPoint.sm;

  const ResponsiveContainer.md({required this.child, super.key})
      : breakPoint = BreakPoint.md;

  const ResponsiveContainer.lg({required this.child, super.key})
      : breakPoint = BreakPoint.lg;

  const ResponsiveContainer.xl({required this.child, super.key})
      : breakPoint = BreakPoint.xl;

  const ResponsiveContainer.xxl({required this.child, super.key})
      : breakPoint = BreakPoint.xxl;

  final Widget child;

  final BreakPoint breakPoint;

  @override
  Widget build(BuildContext context) {
    // 	Extra small <576px	- 100 %
    // 	Small ≥576px	- 540px
    // 	Medium ≥768px	- 720px
    // 	Large ≥992px	- 960px
    // 	X-Large ≥1200px	- 1140px
    // 	XX-Large ≥1400px- 1320px
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        var maxWidth = width;

        if (width >= 1400 && (breakPoint.order >= BreakPoint.xxl.order)) {
          maxWidth = 1320;
        } else if (width >= 1200 && (breakPoint.order >= BreakPoint.xl.order)) {
          maxWidth = 1140;
        } else if (width >= 992 && (breakPoint.order >= BreakPoint.lg.order)) {
          maxWidth = 960;
        } else if (width >= 768 && (breakPoint.order >= BreakPoint.md.order)) {
          maxWidth = 720;
        } else if (width >= 576 && (breakPoint.order >= BreakPoint.sm.order)) {
          maxWidth = 540;
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      },
    );
  }
}
