import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/currency.dart';
import '../../shared/models/debt_operation.dart';
import '../../shared/models/transaction_type.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Transactions, ExchangeRateCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'income_outcome',
          // Assets live in web/ and are copied into the build output.
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 cached placeholder rates; drop them so the first launch on the
        // live feed refetches. Transaction snapshots stay untouched.
        await delete(exchangeRateCache).go();
      }
      if (from < 3) {
        // Forward-only, additive columns. No existing row is rewritten.
        await m.addColumn(transactions, transactions.subcategoryId);
        await m.addColumn(transactions, transactions.debtOperation);
        await m.addColumn(exchangeRateCache, exchangeRateCache.sourceUpdatedAt);
        await m.addColumn(exchangeRateCache, exchangeRateCache.cachedAt);
        await m.addColumn(exchangeRateCache, exchangeRateCache.baseCurrency);
        await _createIndexes();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_date '
      'ON transactions (transaction_date)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_type_category '
      'ON transactions (type, category_id, subcategory_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_transactions_debt '
      'ON transactions (debt_operation)',
    );
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});
