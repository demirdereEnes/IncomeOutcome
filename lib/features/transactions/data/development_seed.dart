import '../../../shared/models/currency.dart';
import '../../../shared/models/transaction_type.dart';
import '../../rates/domain/exchange_rates.dart';
import '../domain/transaction.dart';
import 'transaction_repository.dart';

/// Fills an empty database with a realistic history so the dashboard, chart
/// and movement list can be exercised. Debug builds only - never called in
/// release, and never overwrites data the user already has.
Future<void> seedDevelopmentDataIfEmpty(TransactionRepository repository) async {
  if (await repository.count() > 0) return;

  final today = DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);

  await repository.createAll([
    for (final seed in _seeds) _toNewTransaction(seed, midnight),
  ]);
}

NewTransaction _toNewTransaction(_Seed seed, DateTime midnight) {
  final date = midnight.subtract(Duration(days: seed.daysAgo));

  return NewTransaction(
    type: seed.type,
    currency: seed.currency,
    amountMinor: (seed.amount * 100).round(),
    categoryId: seed.categoryId,
    transactionDate: date,
    description: seed.description,
    rates: ExchangeRates(
      usdTry: 48.2538 - seed.daysAgo * 0.035,
      eurTry: 55.9646 - seed.daysAgo * 0.042,
      xauTry: 6908.74 - seed.daysAgo * 7.6,
      fetchedAt: date.add(const Duration(hours: 9, minutes: 30)),
      source: 'seed',
    ),
  );
}

const _seeds = <_Seed>[
  _Seed(40, TransactionType.income, 1, Currency.tryLira, 125000, 'Temmuz maaşı'),
  _Seed(39, TransactionType.expense, 7, Currency.tryLira, 2450, null),
  _Seed(38, TransactionType.expense, 9, Currency.tryLira, 1250, null),
  _Seed(35, TransactionType.expense, 8, Currency.tryLira, 950, 'Elektrik faturası'),
  _Seed(33, TransactionType.income, 2, Currency.usd, 1200, 'Landing page projesi'),
  _Seed(30, TransactionType.expense, 14, Currency.tryLira, 5000, null),
  _Seed(28, TransactionType.saving, 16, Currency.xau, 5, 'Gram altın alımı'),
  _Seed(27, TransactionType.expense, 10, Currency.tryLira, 1850, null),
  _Seed(24, TransactionType.expense, 7, Currency.tryLira, 3120, null),
  _Seed(20, TransactionType.expense, 13, Currency.tryLira, 900, null),
  _Seed(18, TransactionType.income, 5, Currency.tryLira, 18000, 'Daire kirası'),
  _Seed(16, TransactionType.saving, 17, Currency.usd, 500, 'Dolar birikimi'),
  _Seed(15, TransactionType.expense, 11, Currency.tryLira, 2400, null),
  _Seed(12, TransactionType.expense, 8, Currency.tryLira, 1340, 'Doğalgaz'),
  _Seed(10, TransactionType.income, 1, Currency.tryLira, 128500, 'Ağustos maaşı'),
  _Seed(8, TransactionType.expense, 7, Currency.tryLira, 2780, null),
  _Seed(6, TransactionType.saving, 18, Currency.eur, 300, 'Euro mevduat'),
  _Seed(5, TransactionType.expense, 12, Currency.tryLira, 1600, 'Okul kırtasiye'),
  _Seed(3, TransactionType.income, 3, Currency.tryLira, 12000, 'Çeyrek primi'),
  _Seed(2, TransactionType.expense, 9, Currency.usd, 60, 'Benzin'),
  _Seed(1, TransactionType.saving, 16, Currency.xau, 2.5, null),
];

class _Seed {
  const _Seed(
    this.daysAgo,
    this.type,
    this.categoryId,
    this.currency,
    this.amount,
    this.description,
  );

  final int daysAgo;
  final TransactionType type;
  final int categoryId;
  final Currency currency;
  final double amount;
  final String? description;
}
