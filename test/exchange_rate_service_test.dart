import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_service.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
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

Dio _dioReturning(String body) => Dio()..httpClientAdapter = _StubAdapter(body);

void main() {
  test('parses USD, EUR and gram gold selling prices', () async {
    final service = ApiExchangeRateService(
      _dioReturning('''
      {
        "Meta_Data": {"Update_Date": "2026-08-29 02:05:02"},
        "Rates": {
          "USD": {"Buying": 48.2203, "Selling": 48.2538, "Type": "Currency"},
          "EUR": {"Buying": 55.8755, "Selling": 55.9646, "Type": "Currency"},
          "GRA": {"Buying": 6907.88, "Selling": 6908.74, "Type": "Gold"},
          "GUMUS": {"Buying": 102.9, "Selling": 102.97, "Type": "Gold"}
        }
      }
      '''),
    );

    final rates = await service.fetchRates();

    expect(rates.usdTry, 48.2538);
    expect(rates.eurTry, 55.9646);
    expect(rates.xauTry, 6908.74);
    expect(rates.source, 'truncgil');
  });

  test('accepts string quotes and falls back to the buying price', () async {
    final service = ApiExchangeRateService(
      _dioReturning('''
      {
        "Rates": {
          "USD": {"Buying": "48,25"},
          "EUR": {"Selling": "55.96"},
          "GRA": {"Selling": "6908.74"}
        }
      }
      '''),
    );

    final rates = await service.fetchRates();

    expect(rates.usdTry, 48.25);
    expect(rates.eurTry, 55.96);
    expect(rates.xauTry, 6908.74);
  });

  test('rejects a payload without the expected quotes', () async {
    final service = ApiExchangeRateService(
      _dioReturning('{"Rates": {"USD": {"Selling": 48.25}}}'),
    );

    await expectLater(
      service.fetchRates(),
      throwsA(isA<ExchangeRateFormatException>()),
    );
  });
}
