import 'package:drift/drift.dart';

import '../../shared/models/currency.dart';
import '../../shared/models/debt_operation.dart';
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

  /// Added in schema v3; null for rows created before subcategories existed.
  IntColumn get subcategoryId => integer().nullable()();

  /// Added in schema v3. Non-null rows are debt movements, not spending.
  TextColumn get debtOperation => textEnum<DebtOperation>().nullable()();

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

  /// When the app successfully retrieved the response.
  DateTimeColumn get fetchedAt => dateTime()();

  /// Quote time reported by the provider. Added in v3; null when the provider
  /// exposes no trustworthy source timestamp.
  DateTimeColumn get sourceUpdatedAt => dateTime().nullable()();

  /// When the row was persisted locally. Added in v3.
  DateTimeColumn get cachedAt => dateTime().nullable()();

  /// Base currency of the upstream response. Added in v3.
  TextColumn get baseCurrency => text().nullable().withLength(max: 8)();

  TextColumn get source => text().withLength(max: 40)();
}
