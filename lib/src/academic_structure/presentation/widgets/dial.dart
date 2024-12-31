import 'package:flutter/material.dart';

class Dial extends StatelessWidget {
  const Dial({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // up and down buttons
        GestureDetector(
          child: const Icon(Icons.arrow_drop_up),
          onTap: () {
            final currentValue = int.tryParse(controller.text) ?? 0;
            if (currentValue >= 900) return;
            controller.text = (currentValue + 100).toString();
          },
        ),
        GestureDetector(
          child: const Icon(Icons.arrow_drop_down),
          onTap: () {
            final currentValue = int.tryParse(controller.text) ?? 0;
            if (currentValue <= 100) return;
            controller.text = (currentValue - 100).toString();
          },
        ),
      ],
    );
  }
}
