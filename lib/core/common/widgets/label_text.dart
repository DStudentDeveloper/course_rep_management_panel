import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.data, {this.required = false, super.key});

  final String data;
  final bool required;

  @override
  Widget build(BuildContext context) {
    if (required) {
      return Text.rich(
        TextSpan(
          text: data,
          style: context.theme.textTheme.titleMedium,
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }
    return Text(
      data,
      style: context.theme.textTheme.titleMedium,
    );
  }
}
