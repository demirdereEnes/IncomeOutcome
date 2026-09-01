import 'package:income_outcome/features/rates/domain/exchange_rates.dart';
import 'package:income_outcome/features/transactions/domain/transaction.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/debt_operation.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';

final testRates = ExchangeRates(
  usdTry: 41.2536,
  eurTry: 48.1120,
  xauTry: 5842.30,
  fetchedAt: DateTime(2026, 8, 29, 9, 30),
  source: 'test',
);

var _nextId = 1;

Transaction tx({
  int? id,
  required TransactionType type,
  Currency currency = Currency.tryLira,
  required double amount,
  int categoryId = 100,
  int? subcategoryId,
  DebtOperation? debtOperation,
  ExchangeRates? rates,
  DateTime? date,
}) {
  final when = date ?? DateTime(2026, 8, 29);
  final snapshot = rates ?? testRates;
  return Transaction(
    id: id ?? _nextId++,
    type: type,
    currency: currency,
    amountMinor: (amount * 100).round(),
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    debtOperation: debtOperation,
    transactionDate: when,
    rates: snapshot,
    rateSnapshotAt: snapshot.fetchedAt,
    createdAt: when,
    updatedAt: when,
  );
}

void resetTestIds() => _nextId = 1;
