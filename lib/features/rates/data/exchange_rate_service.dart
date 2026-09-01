import 'package:dio/dio.dart';

import '../domain/exchange_rates.dart';
import 'rate_log.dart';

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

/// ExchangeRate.fun, USD based, no API key.
///
/// The feed quotes everything per 1 USD, so `rates["XAU"]` is *troy ounces of
/// gold per USD*. The app works in grams, hence the explicit conversion in
/// [_goldTryPerGram]; a raw XAU value must never reach the UI.
class ApiExchangeRateService implements ExchangeRateService {
  const ApiExchangeRateService(this._dio);

  static const String endpoint = 'https://api.exchangerate.fun/latest?base=USD';

  final Dio _dio;

  @override
  Future<ExchangeRates> fetchRates() async {
    logRates('HTTP request started');
    final response = await _dio.get<Map<String, dynamic>>(endpoint);
    logRates('HTTP response received (${response.statusCode})');

    final body = response.data;
    final rates = body?['rates'];
    if (body == null || rates is! Map) {
      throw const ExchangeRateFormatException('missing rates payload');
    }

    final usdTry = _positive(rates['TRY'], 'TRY');
    final eurPerUsd = _positive(rates['EUR'], 'EUR');
    final xauPerUsd = _positive(rates['XAU'], 'XAU');

    final result = ExchangeRates(
      usdTry: usdTry,
      eurTry: usdTry / eurPerUsd,
      xauTry: _goldTryPerGram(usdTry: usdTry, xauPerUsd: xauPerUsd),
      fetchedAt: DateTime.now(),
      sourceUpdatedAt: _sourceUpdatedAt(body['timestamp']),
      baseCurrency: body['base'] is String ? body['base'] as String : 'USD',
      source: 'exchangerate.fun',
    );

    logRates('Response validated');
    return result;
  }

  /// TRY per troy ounce, divided by the grams in a troy ounce.
  static double _goldTryPerGram({
    required double usdTry,
    required double xauPerUsd,
  }) {
    final tryPerTroyOunce = usdTry / xauPerUsd;
    final perGram = tryPerTroyOunce / ExchangeRates.gramsPerTroyOunce;
    if (!perGram.isFinite || perGram <= 0) {
      throw const ExchangeRateFormatException('gold conversion failed');
    }
    return perGram;
  }

  static DateTime? _sourceUpdatedAt(Object? value) {
    if (value is! num) return null;
    final seconds = value.toInt();
    if (seconds <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  static double _positive(Object? value, String code) {
    final parsed = switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text),
      _ => null,
    };
    if (parsed == null || !parsed.isFinite || parsed <= 0) {
      throw ExchangeRateFormatException('invalid quote for $code');
    }
    return parsed;
  }
}
