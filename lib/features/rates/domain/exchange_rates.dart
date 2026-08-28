import '../../../shared/models/currency.dart';

/// TRY-denominated rates captured at a point in time.
///
/// Two distinct uses, deliberately kept apart:
/// * attached to a transaction it becomes an immutable historical snapshot;
/// * held by the rates repository it is the current, refreshable value.
class ExchangeRates {
  const ExchangeRates({
    required this.usdTry,
    required this.eurTry,
    required this.xauTry,
    required this.fetchedAt,
    this.source = 'unknown',
  });

  /// How long a cached quote stays usable before a refresh is attempted.
  static const Duration cacheTtl = Duration(hours: 3);

  final double usdTry;
  final double eurTry;

  /// Price of one gram of gold in TRY.
  final double xauTry;

  final DateTime fetchedAt;
  final String source;

  /// How many TRY one unit of [currency] is worth.
  double rateFor(Currency currency) => switch (currency) {
    Currency.tryLira => 1,
    Currency.usd => usdTry,
    Currency.eur => eurTry,
    Currency.xau => xauTry,
  };

  bool isStaleAt(DateTime now) => now.difference(fetchedAt) > cacheTtl;
}
