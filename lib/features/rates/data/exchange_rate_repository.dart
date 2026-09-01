import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/exchange_rates.dart';
import 'exchange_rate_service.dart';
import 'rate_log.dart';

/// Outcome of a rate load.
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

  /// Always performs a real request; the caller decides when that is allowed.
  /// An invalid response throws before anything is written, so a valid cache
  /// can never be overwritten with junk.
  Future<ExchangeRates> refresh() async {
    final rates = await _service.fetchRates();
    final cachedAt = DateTime.now();

    await _db
        .into(_db.exchangeRateCache)
        .insert(
          ExchangeRateCacheCompanion.insert(
            usdTryRate: rates.usdTry,
            eurTryRate: rates.eurTry,
            xauTryRate: rates.xauTry,
            fetchedAt: rates.fetchedAt,
            sourceUpdatedAt: Value(rates.sourceUpdatedAt),
            cachedAt: Value(cachedAt),
            baseCurrency: Value(rates.baseCurrency),
            source: rates.source,
          ),
        );

    logRates('Cache updated, fetchedAt = ${_hhmm(rates.fetchedAt)}');
    return rates;
  }

  /// Uses the cache while it is younger than [ExchangeRates.cacheTtl],
  /// otherwise refreshes and falls back to the cache when that fails.
  Future<RatesLoadResult> load() async {
    final cached = await readCached();
    final now = DateTime.now();

    if (cached == null) {
      logRates('No cache found');
    } else {
      final age = now.difference(cached.fetchedAt);
      logRates('Cache found, fetchedAt = ${_hhmm(cached.fetchedAt)}');
      logRates('Cache age = ${age.inHours}h ${age.inMinutes % 60}m');
    }

    if (cached != null && !cached.isStaleAt(now)) {
      logRates('Cache is fresh, no request');
      return RatesLoadResult(rates: cached);
    }

    logRates(cached == null ? 'Fetching first quote' : 'Cache expired');
    try {
      return RatesLoadResult(rates: await refresh());
    } on Object catch (error) {
      logRates('Refresh failed ($error), keeping cache');
      return RatesLoadResult(rates: cached, refreshFailed: true);
    }
  }

  /// Explicit user action: bypasses the TTL entirely.
  Future<RatesLoadResult> manualRefresh() async {
    logRates('Manual refresh requested');
    final cached = await readCached();
    try {
      return RatesLoadResult(rates: await refresh());
    } on Object catch (error) {
      logRates('Manual refresh failed ($error), keeping cache');
      return RatesLoadResult(rates: cached, refreshFailed: true);
    }
  }

  static String _hhmm(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  static ExchangeRates _toDomain(ExchangeRateRow row) => ExchangeRates(
    usdTry: row.usdTryRate,
    eurTry: row.eurTryRate,
    xauTry: row.xauTryRate,
    fetchedAt: row.fetchedAt,
    sourceUpdatedAt: row.sourceUpdatedAt,
    baseCurrency: row.baseCurrency,
    source: row.source,
  );
}
