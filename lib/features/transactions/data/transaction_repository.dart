import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../rates/domain/exchange_rates.dart';
import '../domain/transaction.dart';

/// The only place that touches the transactions table.
class TransactionRepository {
  TransactionRepository(this._db);

  final AppDatabase _db;

  Stream<List<Transaction>> watchAll() {
    final query = _db.select(_db.transactions)
      ..orderBy([
        (t) => OrderingTerm.desc(t.transactionDate),
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<int> count() async {
    final expression = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)..addColumns([expression]);
    final row = await query.getSingle();
    return row.read(expression) ?? 0;
  }

  Future<int> create(NewTransaction transaction) =>
      _db.into(_db.transactions).insert(_toCompanion(transaction));

  Future<void> createAll(List<NewTransaction> items) async {
    await _db.batch((batch) {
      batch.insertAll(_db.transactions, items.map(_toCompanion));
    });
  }

  Future<void> deleteById(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  static TransactionsCompanion _toCompanion(NewTransaction transaction) {
    final now = DateTime.now();
    final rates = transaction.rates;

    return TransactionsCompanion.insert(
      type: transaction.type,
      currency: transaction.currency,
      amountMinor: transaction.amountMinor,
      categoryId: transaction.categoryId,
      subcategoryId: Value(transaction.subcategoryId),
      debtOperation: Value(transaction.debtOperation),
      transactionDate: transaction.transactionDate,
      description: Value(transaction.description),
      usdTryRate: Value(rates?.usdTry),
      eurTryRate: Value(rates?.eurTry),
      xauTryRate: Value(rates?.xauTry),
      rateSnapshotAt: Value(rates?.fetchedAt),
      createdAt: now,
      updatedAt: now,
    );
  }

  static Transaction _toDomain(TransactionRow row) {
    final usd = row.usdTryRate;
    final eur = row.eurTryRate;
    final xau = row.xauTryRate;
    final snapshotAt = row.rateSnapshotAt;

    final hasSnapshot =
        usd != null && eur != null && xau != null && snapshotAt != null;

    return Transaction(
      id: row.id,
      type: row.type,
      currency: row.currency,
      amountMinor: row.amountMinor,
      categoryId: row.categoryId,
      subcategoryId: row.subcategoryId,
      debtOperation: row.debtOperation,
      transactionDate: row.transactionDate,
      description: row.description,
      rates: hasSnapshot
          ? ExchangeRates(
              usdTry: usd,
              eurTry: eur,
              xauTry: xau,
              fetchedAt: snapshotAt,
              source: 'snapshot',
            )
          : null,
      rateSnapshotAt: snapshotAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
