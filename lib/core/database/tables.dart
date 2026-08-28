import 'package:drift/drift.dart';

import '../../shared/models/currency.dart';
import '../../shared/models/transaction_type.dart';

@DataClassName('TransactionRow')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get type => textEnum<TransactionType>()();

  /// Currency the user entered the amount in.
  TextColumn get currency => textEnum<Currency>()();

  /// Amount in [currency], scaled by 100 so no float rounding can creep in.
  IntColumn get amountMinor => integer()();

  IntColumn get categoryId => integer()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get description => text().nullable()();

  // Immutable rate snapshot taken when the entry was saved. Nullable so a TRY
  // entry can still be recorded when no quote has ever been fetched.
  RealColumn get usdTryRate => real().nullable()();
  RealColumn get eurTryRate => real().nullable()();
  RealColumn get xauTryRate => real().nullable()();
  DateTimeColumn get rateSnapshotAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('ExchangeRateRow')
class ExchangeRateCache extends Table {
  @override
  String get tableName => 'exchange_rates';

  IntColumn get id => integer().autoIncrement()();
  RealColumn get usdTryRate => real()();
  RealColumn get eurTryRate => real()();
  RealColumn get xauTryRate => real()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text().withLength(max: 40)();
}
