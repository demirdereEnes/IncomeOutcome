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
    this.sourceUpdatedAt,
    this.baseCurrency,
    this.source = 'unknown',
  });

  /// How long a cached quote stays usable before a refresh is attempted.
  static const Duration cacheTtl = Duration(hours: 3);

  /// One troy ounce in grams, used to turn a XAU/oz quote into TRY per gram.
  static const double gramsPerTroyOunce = 31.1034768;

  final double usdTry;
  final double eurTry;

  /// Price of one **gram** of gold in TRY.
  final double xauTry;

  /// When this app successfully retrieved the response. Never changed by
  /// opening the app, a screen or a widget.
  final DateTime fetchedAt;

  /// Quote time reported by the provider, when it exposes a trustworthy one.
  final DateTime? sourceUpdatedAt;

  final String? baseCurrency;
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
