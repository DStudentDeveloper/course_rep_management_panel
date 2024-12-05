import 'package:course_rep_management_panel/core/extensions/context_extensions.dart';
import 'package:course_rep_management_panel/core/utils/enums/input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormField extends StatelessWidget {
  const InputFormField({
    required this.controller,
    this.label,
    this.suffixIcon,
    this.onSubmitted,
    this.required = false,
    this.readOnly = false,
    this.border = InputBorderType.underline,
    this.width,
    this.inputFormatters,
    this.prefixText,
    this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final bool required;
  final String? label;
  final InputBorderType border;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;
  final double? width;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final String? hintText;
  final bool readOnly;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onSubmitted,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: required ? null : label,
          prefixText: prefixText,
          hintText: hintText,
          label: required && label != null ?  Text.rich(
            TextSpan(
              text: label,
              style: context.theme.inputDecorationTheme.labelStyle,
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ) : null,
          border: switch(border) {
            InputBorderType.none => InputBorder.none,
            InputBorderType.underline => const UnderlineInputBorder(),
            InputBorderType.outline => const OutlineInputBorder(),
          },
          suffixIcon: suffixIcon,
        ),
        inputFormatters: inputFormatters,
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
