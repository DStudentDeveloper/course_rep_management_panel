import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HundredsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    debugPrint('New Value: ${newValue.text}');
    debugPrint('Old Value: ${oldValue.text}');
    final newText = newValue.text.replaceFirst(oldValue.text, '');
    debugPrint('New Text: $newText');
    // Ensure the input is numeric
    if (newText.isEmpty) return newValue;

    final inputNumber = int.tryParse(newText.trim());
    if (inputNumber != null && inputNumber > 0) {
      // Format the input as multiples of 100
      var formattedValue = (inputNumber * 100).toString();
      if (formattedValue.length > 3) {
        formattedValue = formattedValue.substring(0, 3);
      }
      if (int.parse(formattedValue) % 100 != 0) {
        formattedValue = '100';
      }
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    } else {
      return oldValue; // Revert to old value if invalid input
    }
  }
}
