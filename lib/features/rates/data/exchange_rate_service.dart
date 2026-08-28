import 'package:dio/dio.dart';

import '../domain/exchange_rates.dart';

/// Source of live rates. Swapping in a different provider must not require
/// touching the repository, the providers or the UI.
abstract interface class ExchangeRateService {
  Future<ExchangeRates> fetchRates();
}

class ExchangeRateFormatException implements Exception {
  const ExchangeRateFormatException(this.message);

  final String message;

  @override
  String toString() => 'ExchangeRateFormatException: $message';
}

/// Reads USD/TRY, EUR/TRY and gram gold from a free Turkish market feed.
///
/// The endpoint needs no API key, sends `Access-Control-Allow-Origin: *` and
/// refreshes about once a minute; our own 3 hour cache keeps traffic low.
class ApiExchangeRateService implements ExchangeRateService {
  const ApiExchangeRateService(this._dio);

  static const String endpoint = 'https://finance.truncgil.com/api/today.json';

  /// Feed key for gram gold ("gram altın").
  static const String _goldKey = 'GRA';

  final Dio _dio;

  @override
  Future<ExchangeRates> fetchRates() async {
    final response = await _dio.get<Map<String, dynamic>>(endpoint);
    final rates = response.data?['Rates'];
    if (rates is! Map) {
      throw const ExchangeRateFormatException('missing rates payload');
    }

    return ExchangeRates(
      usdTry: _price(rates, 'USD'),
      eurTry: _price(rates, 'EUR'),
      xauTry: _price(rates, _goldKey),
      fetchedAt: DateTime.now(),
      source: 'truncgil',
    );
  }

  /// Selling price, falling back to the buying price if the feed omits it.
  static double _price(Map<dynamic, dynamic> rates, String code) {
    final entry = rates[code];
    if (entry is! Map) {
      throw ExchangeRateFormatException('missing quote for $code');
    }

    final value = _toDouble(entry['Selling']) ?? _toDouble(entry['Buying']);
    if (value == null || value <= 0) {
      throw ExchangeRateFormatException('invalid quote for $code');
    }
    return value;
  }

  static double? _toDouble(Object? value) => switch (value) {
    final num number => number.toDouble(),
    final String text => double.tryParse(text.replaceAll(',', '.')),
    _ => null,
  };
}
