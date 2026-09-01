import '../../../shared/models/currency.dart';
import '../../../shared/models/debt_operation.dart';
import '../../../shared/models/transaction_type.dart';
import '../../rates/domain/exchange_rates.dart';
import '../domain/transaction.dart';
import 'transaction_repository.dart';

/// Fills an empty database with a realistic history so the dashboard, charts,
/// filters and debt tracking can be exercised. Debug builds only - never
/// called in release, and never written over data the user already has.
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
    subcategoryId: seed.subcategoryId,
    debtOperation: seed.debtOperation,
    transactionDate: date,
    description: seed.description,
    rates: ExchangeRates(
      usdTry: 48.2613 - seed.daysAgo * 0.032,
      eurTry: 55.9825 - seed.daysAgo * 0.038,
      xauTry: 6855.63 - seed.daysAgo * 7.4,
      fetchedAt: date.add(const Duration(hours: 9, minutes: 30)),
      source: 'seed',
    ),
  );
}

const _seeds = <_Seed>[
  _Seed(45, TransactionType.income, 100, null, Currency.tryLira, 125000, 'Temmuz maaşı'),
  _Seed(44, TransactionType.expense, 110, 11000, Currency.tryLira, 20000, 'Kira'),
  _Seed(43, TransactionType.expense, 113, 11300, Currency.tryLira, 4200, null),
  _Seed(41, TransactionType.expense, 112, 11200, Currency.tryLira, 3500, 'Benzin'),
  _Seed(40, TransactionType.expense, 111, 11100, Currency.tryLira, 950, 'Elektrik'),
  _Seed(38, TransactionType.expense, 111, 11103, Currency.tryLira, 600, 'İnternet'),
  _Seed(37, TransactionType.expense, 115, 11500, Currency.tryLira, 500, 'Netflix'),
  _Seed(35, TransactionType.saving, 130, null, Currency.xau, 5, 'Gram altın'),
  _Seed(33, TransactionType.expense, 113, 11301, Currency.tryLira, 1850, null),
  _Seed(30, TransactionType.income, 102, null, Currency.usd, 1200, 'Freelance proje'),
  _Seed(28, TransactionType.expense, 116, 11601, Currency.tryLira, 8400, 'Kulaklık'),
  _Seed(25, TransactionType.expense, 112, 11205, Currency.tryLira, 2300, 'MTV'),
  _Seed(22, TransactionType.expense, 114, 11400, Currency.tryLira, 3100, 'Okul'),
  _Seed(20, TransactionType.saving, 133, null, Currency.tryLira, 100000, 'Nakit birikim'),
  _Seed(
    18,
    TransactionType.expense,
    118,
    11802,
    Currency.xau,
    105,
    'Altın borcu',
    debtOperation: DebtOperation.add,
  ),
  _Seed(15, TransactionType.expense, 113, 11300, Currency.tryLira, 5800, null),
  _Seed(12, TransactionType.expense, 117, 11703, Currency.tryLira, 6500, 'Hafta sonu'),
  _Seed(10, TransactionType.income, 100, null, Currency.tryLira, 128500, 'Ağustos maaşı'),
  _Seed(8, TransactionType.expense, 110, 11001, Currency.tryLira, 1400, 'Aidat'),
  _Seed(5, TransactionType.expense, 112, 11200, Currency.tryLira, 3500, null),
  _Seed(3, TransactionType.expense, 115, 11503, Currency.usd, 20, 'ChatGPT'),
  _Seed(1, TransactionType.expense, 113, 11303, Currency.tryLira, 480, 'Kahve'),
];

class _Seed {
  const _Seed(
    this.daysAgo,
    this.type,
    this.categoryId,
    this.subcategoryId,
    this.currency,
    this.amount,
    this.description, {
    this.debtOperation,
  });

  final int daysAgo;
  final TransactionType type;
  final int categoryId;
  final int? subcategoryId;
  final Currency currency;
  final double amount;
  final String? description;
  final DebtOperation? debtOperation;
}
