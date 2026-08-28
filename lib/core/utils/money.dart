/// Conversions between the user-facing amount string and TRY minor units.
abstract final class Money {
  /// Parses `"5.000,50"` / `"5000,5"` / `"5000"` into kuruş.
  /// Returns `null` when the text holds no usable number.
  static int? tryParseMinor(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9,.]'), '');
    if (cleaned.isEmpty) return null;

    // Turkish input: '.' groups thousands, ',' opens the decimal part.
    final normalized = cleaned.replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(normalized);
    if (value == null) return null;

    return (value * 100).round();
  }

  static String minorToInput(int minor) {
    final major = minor ~/ 100;
    final fraction = minor % 100;
    return fraction == 0
        ? '$major'
        : '$major,${fraction.toString().padLeft(2, '0')}';
  }
}
