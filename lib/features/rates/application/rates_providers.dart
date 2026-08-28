import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/network/dio_client.dart';
import '../data/exchange_rate_repository.dart';
import '../data/exchange_rate_service.dart';
import '../domain/exchange_rates.dart';

final exchangeRateServiceProvider = Provider<ExchangeRateService>(
  (ref) => ApiExchangeRateService(ref.watch(dioProvider)),
);

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return ExchangeRateRepository(
    database: ref.watch(appDatabaseProvider),
    rateService: ref.watch(exchangeRateServiceProvider),
  );
});

/// Current rates, cache-first. Never blocks the dashboard - only the entry
/// form needs them, and only at save time.
final currentRatesProvider = FutureProvider<RatesLoadResult>(
  (ref) => ref.watch(exchangeRateRepositoryProvider).load(),
);

/// Convenience accessor for callers that only care about the value.
final currentExchangeRatesProvider = Provider<ExchangeRates?>(
  (ref) => ref.watch(currentRatesProvider).value?.rates,
);
