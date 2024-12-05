import 'package:flutter/material.dart';

enum LogLevel {
  info(Colors.blue),
  warning(Colors.orange),
  error(Colors.red),
  success(Colors.green);

  const LogLevel(this.color);

  final Color color;
}
