import 'package:intl/intl.dart';

import '../../shared/models/currency.dart';

/// Single place for every user-facing number/date string.
abstract final class Formatters {
  static const String _locale = 'tr_TR';

  static final NumberFormat _decimal = NumberFormat('#,##0.00', _locale);
  static final NumberFormat _compact = NumberFormat('#,##0.#', _locale);
  static final DateFormat _fullDate = DateFormat('d MMMM y', _locale);
  static final DateFormat _shortDate = DateFormat('d MMMM', _locale);
  static final DateFormat _axisDate = DateFormat('d MMM', _locale);
  static final DateFormat _timeOfDay = DateFormat('HH:mm', _locale);

  /// `₺125.000,50`, `$3.025,75`, `€2.750,20`, `12,45 gr`
  static String money(double amount, Currency currency) {
    final formatted = _decimal.format(amount);
    return currency.symbolIsPrefix
        ? '${currency.symbol}$formatted'
        : '$formatted${currency.symbol}';
  }

  /// Same as [money] but with an explicit `+` / `-` sign.
  static String signedMoney(
    double amount,
    Currency currency, {
    bool negative = false,
  }) {
    return '${negative ? '-' : '+'} ${money(amount.abs(), currency)}';
  }

  /// Converted value shown under the original amount: `≈ ₺41.253,60`.
  static String approx(double amount, Currency currency) =>
      '≈ ${money(amount, currency)}';

  /// Compact form used on chart axes: `60K`, `1,2M`.
  static String compact(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign${_trimZero(abs / 1000000)}M';
    if (abs >= 1000) return '$sign${_trimZero(abs / 1000)}K';
    return '$sign${_trimZero(abs)}';
  }

  /// Raw rate value shown in the snapshot card, e.g. `41,2536`.
  static String rate(double value, {int decimals = 4}) =>
      NumberFormat('#,##0.${'0' * decimals}', _locale).format(value);

  static String fullDate(DateTime date) => _fullDate.format(date);

  static String shortDate(DateTime date) => _shortDate.format(date);

  static String axisDate(DateTime date) => _axisDate.format(date);

  static String time(DateTime date) => _timeOfDay.format(date);

  static String _trimZero(double value) => _compact.format(value);
}
