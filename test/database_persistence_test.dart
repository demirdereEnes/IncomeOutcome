import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/core/database/app_database.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_repository.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_service.dart';
import 'package:income_outcome/features/rates/domain/exchange_rates.dart';
import 'package:income_outcome/features/transactions/data/transaction_repository.dart';
import 'package:income_outcome/features/transactions/domain/transaction.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';

class _FailingRateService implements ExchangeRateService {
  @override
  Future<ExchangeRates> fetchRates() async => throw Exception('offline');
}

class _StubRateService implements ExchangeRateService {
  const _StubRateService();

  @override
  Future<ExchangeRates> fetchRates() async => ExchangeRates(
    usdTry: 41.2536,
    eurTry: 48.1120,
    xauTry: 5842.30,
    fetchedAt: DateTime.now(),
    source: 'stub',
  );
}

void main() {
  late AppDatabase database;
  late TransactionRepository transactions;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    transactions = TransactionRepository(database);
  });

  tearDown(() => database.close());

  final rates = ExchangeRates(
    usdTry: 41.2536,
    eurTry: 48.1120,
    xauTry: 5842.30,
    fetchedAt: DateTime(2026, 8, 29, 9, 30),
    source: 'test',
  );

  test('a saved entry survives a fresh read with its snapshot intact', () async {
    await transactions.create(
      NewTransaction(
        type: TransactionType.expense,
        currency: Currency.usd,
        amountMinor: 10000,
        categoryId: 9,
        transactionDate: DateTime(2026, 8, 29),
        description: 'Benzin',
        rates: rates,
      ),
    );

    final stored = await transactions.watchAll().first;

    expect(stored, hasLength(1));
    expect(stored.single.currency, Currency.usd);
    expect(stored.single.amount, 100);
    expect(stored.single.description, 'Benzin');
    expect(stored.single.rates?.usdTry, 41.2536);
    expect(stored.single.tryAmountSnapshot, closeTo(4125.36, 0.001));
  });

  test('deleting removes the entry', () async {
    final id = await transactions.create(
      NewTransaction(
        type: TransactionType.income,
        currency: Currency.tryLira,
        amountMinor: 12500000,
        categoryId: 1,
        transactionDate: DateTime(2026, 8, 29),
        rates: rates,
      ),
    );

    expect(await transactions.count(), 1);
    await transactions.deleteById(id);
    expect(await transactions.count(), 0);
  });

  test('a TRY entry can be stored without any rate snapshot', () async {
    await transactions.create(
      NewTransaction(
        type: TransactionType.income,
        currency: Currency.tryLira,
        amountMinor: 500000,
        categoryId: 1,
        transactionDate: DateTime(2026, 8, 29),
      ),
    );

    final stored = (await transactions.watchAll().first).single;
    expect(stored.rates, isNull);
    expect(stored.amountIn(Currency.tryLira), 5000);
  });

  group('exchange rate cache', () {
    test('serves the cache while it is fresh instead of refetching', () async {
      final repository = ExchangeRateRepository(
        database: database,
        rateService: const _StubRateService(),
      );

      final first = await repository.load();
      expect(first.rates, isNotNull);
      expect(first.refreshFailed, isFalse);

      await repository.load();

      // A second load inside the TTL must not hit the service again.
      final cached = await database.select(database.exchangeRateCache).get();
      expect(cached, hasLength(1));
    });

    test('falls back to the last cached quote when a refresh fails', () async {
      await database
          .into(database.exchangeRateCache)
          .insert(
            ExchangeRateCacheCompanion.insert(
              usdTryRate: 41.2536,
              eurTryRate: 48.1120,
              xauTryRate: 5842.30,
              fetchedAt: DateTime.now().subtract(const Duration(hours: 5)),
              source: 'stale',
            ),
          );

      final offline = ExchangeRateRepository(
        database: database,
        rateService: _FailingRateService(),
      );
      final result = await offline.load();

      expect(result.refreshFailed, isTrue);
      expect(result.rates, isNotNull);
      expect(result.rates!.usdTry, 41.2536);
    });

    test('reports no rates when nothing is cached and the fetch fails', () async {
      final offline = ExchangeRateRepository(
        database: database,
        rateService: _FailingRateService(),
      );
      final result = await offline.load();

      expect(result.rates, isNull);
      expect(result.refreshFailed, isTrue);
    });
  });
}
