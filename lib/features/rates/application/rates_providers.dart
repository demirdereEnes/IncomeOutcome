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

/// Cache-first current rates. Building this never blocks the dashboard - only
/// the entry form needs it, and only at save time.
class CurrentRatesNotifier extends AsyncNotifier<RatesLoadResult> {
  @override
  Future<RatesLoadResult> build() =>
      ref.watch(exchangeRateRepositoryProvider).load();

  /// User-triggered refresh. Bypasses the 3 hour cache and only replaces the
  /// state once a real response has been validated and persisted.
  Future<RatesLoadResult> refreshNow() async {
    final result = await ref
        .read(exchangeRateRepositoryProvider)
        .manualRefresh();
    state = AsyncData(result);
    return result;
  }
}

final currentRatesProvider =
    AsyncNotifierProvider<CurrentRatesNotifier, RatesLoadResult>(
      CurrentRatesNotifier.new,
    );

/// Latest valid rates, used for *current* asset and debt valuation.
final currentExchangeRatesProvider = Provider<ExchangeRates?>(
  (ref) => ref.watch(currentRatesProvider).value?.rates,
);
