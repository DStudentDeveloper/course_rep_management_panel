extension StringExtensions on String {
  /// Converts the string to snake_case.
  ///
  /// Replaces each uppercase letter with an underscore followed by the
  /// lowercase letter, and removes any leading underscores.
  String get snakeCase {
    return replaceAllMapped(
      RegExp('([A-Z])'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp('^_'), '');
  }
}
