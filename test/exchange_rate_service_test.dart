import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_service.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.body);

  final String body;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Real shape of a `https://api.exchangerate.fun/latest?base=USD` response.
const _payload = '''
{
  "timestamp": 1788184800,
  "base": "USD",
  "rates": {
    "AED": 3.6725,
    "EUR": 0.862106,
    "TRY": 48.261254,
    "XAG": 0.01505502,
    "XAU": 0.00022633
  }
}
''';

(ApiExchangeRateService, _StubAdapter) _serviceFor(String body) {
  final adapter = _StubAdapter(body);
  final dio = Dio()..httpClientAdapter = adapter;
  return (ApiExchangeRateService(dio), adapter);
}

void main() {
  test('endpoint matches the specified provider', () {
    expect(
      ApiExchangeRateService.endpoint,
      'https://api.exchangerate.fun/latest?base=USD',
    );
  });

  test('USD/TRY comes straight from the feed', () async {
    final (service, _) = _serviceFor(_payload);
    final rates = await service.fetchRates();

    expect(rates.usdTry, closeTo(48.261254, 0.000001));
  });

  test('EUR/TRY is derived from the USD based quotes', () async {
    final (service, _) = _serviceFor(_payload);
    final rates = await service.fetchRates();

    expect(rates.eurTry, closeTo(48.261254 / 0.862106, 0.0001));
  });

  test('XAU is converted from troy ounces to TRY per gram', () async {
    final (service, _) = _serviceFor(_payload);
    final rates = await service.fetchRates();

    // (TRY per USD / XAU per USD) / 31.1034768
    const expected = (48.261254 / 0.00022633) / 31.1034768;
    expect(rates.xauTry, closeTo(expected, 0.01));
    expect(rates.xauTry, closeTo(6855.63, 1));

    // A troy ounce price must never leak through as a gram price.
    expect(rates.xauTry, lessThan(1 / 0.00022633 * 48.261254));
  });

  test('the provider timestamp is kept as sourceUpdatedAt', () async {
    final (service, _) = _serviceFor(_payload);
    final rates = await service.fetchRates();

    expect(
      rates.sourceUpdatedAt,
      DateTime.fromMillisecondsSinceEpoch(1788184800 * 1000),
    );
    expect(rates.baseCurrency, 'USD');
    expect(rates.source, 'exchangerate.fun');
  });

  test('fetching performs exactly one HTTP request', () async {
    final (service, adapter) = _serviceFor(_payload);
    await service.fetchRates();

    expect(adapter.calls, 1);
  });

  test('a missing currency is rejected', () async {
    final (service, _) = _serviceFor('{"rates": {"TRY": 48.2, "EUR": 0.86}}');

    await expectLater(
      service.fetchRates(),
      throwsA(isA<ExchangeRateFormatException>()),
    );
  });

  test('a non positive quote is rejected', () async {
    final (service, _) = _serviceFor(
      '{"rates": {"TRY": 48.2, "EUR": 0.86, "XAU": 0}}',
    );

    await expectLater(
      service.fetchRates(),
      throwsA(isA<ExchangeRateFormatException>()),
    );
  });

  test('a payload without rates is rejected', () async {
    final (service, _) = _serviceFor('{"timestamp": 1788184800}');

    await expectLater(
      service.fetchRates(),
      throwsA(isA<ExchangeRateFormatException>()),
    );
  });
}
