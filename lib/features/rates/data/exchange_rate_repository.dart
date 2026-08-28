import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/exchange_rates.dart';
import 'exchange_rate_service.dart';

/// Outcome of a cache-first rate load.
class RatesLoadResult {
  const RatesLoadResult({this.rates, this.refreshFailed = false});

  /// Best rates currently available; null only when nothing was ever cached
  /// and the refresh failed.
  final ExchangeRates? rates;

  /// True when a refresh was attempted and failed, so [rates] - if any - are
  /// the last successful quote.
  final bool refreshFailed;

  bool get isUsingStaleFallback => refreshFailed && rates != null;
}

/// Cache-first rate access: SQLite is the source of truth, the network is an
/// optional refresh that must never block or crash the app.
class ExchangeRateRepository {
  ExchangeRateRepository({
    required AppDatabase database,
    required ExchangeRateService rateService,
  }) : _db = database,
       _service = rateService;

  final AppDatabase _db;
  final ExchangeRateService _service;

  Future<ExchangeRates?> readCached() async {
    final query = _db.select(_db.exchangeRateCache)
      ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<ExchangeRates> refresh() async {
    final rates = await _service.fetchRates();
    await _db
        .into(_db.exchangeRateCache)
        .insert(
          ExchangeRateCacheCompanion.insert(
            usdTryRate: rates.usdTry,
            eurTryRate: rates.eurTry,
            xauTryRate: rates.xauTry,
            fetchedAt: rates.fetchedAt,
            source: rates.source,
          ),
        );
    return rates;
  }

  /// Uses the cache while it is younger than [ExchangeRates.cacheTtl],
  /// otherwise refreshes and falls back to the cache when that fails.
  Future<RatesLoadResult> load() async {
    final cached = await readCached();
    if (cached != null && !cached.isStaleAt(DateTime.now())) {
      return RatesLoadResult(rates: cached);
    }

    try {
      return RatesLoadResult(rates: await refresh());
    } on Object {
      return RatesLoadResult(rates: cached, refreshFailed: true);
    }
  }

  static ExchangeRates _toDomain(ExchangeRateRow row) => ExchangeRates(
    usdTry: row.usdTryRate,
    eurTry: row.eurTryRate,
    xauTry: row.xauTryRate,
    fetchedAt: row.fetchedAt,
    source: row.source,
  );
}
