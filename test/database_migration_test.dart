import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/core/database/app_database.dart';
import 'package:income_outcome/features/finance/domain/debt.dart';
import 'package:income_outcome/features/finance/domain/financial_summary.dart';
import 'package:income_outcome/features/transactions/data/transaction_repository.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/debt_operation.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';
import 'package:sqlite3/sqlite3.dart';

/// Schema exactly as Sprint 2 (v2) shipped it, so the upgrade path is
/// exercised against the structure that is live on the user's phone.
const _v2Schema = '''
CREATE TABLE transactions (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL,
  currency TEXT NOT NULL,
  amount_minor INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  transaction_date INTEGER NOT NULL,
  description TEXT NULL,
  usd_try_rate REAL NULL,
  eur_try_rate REAL NULL,
  xau_try_rate REAL NULL,
  rate_snapshot_at INTEGER NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE TABLE exchange_rates (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  usd_try_rate REAL NOT NULL,
  eur_try_rate REAL NOT NULL,
  xau_try_rate REAL NOT NULL,
  fetched_at INTEGER NOT NULL,
  source TEXT NOT NULL
);
''';

int _epoch(DateTime value) => value.millisecondsSinceEpoch ~/ 1000;

void main() {
  late Directory tempDir;
  late File dbFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('income_outcome_migration');
    dbFile = File('${tempDir.path}/app.sqlite');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  /// Writes a realistic v2 database: income, expenses, savings, several
  /// currencies and a cached quote.
  void seedV2Database() {
    final raw = sqlite3.open(dbFile.path);
    raw.execute(_v2Schema);
    raw.execute('PRAGMA user_version = 2');

    final insert = raw.prepare(
      'INSERT INTO transactions (id, type, currency, amount_minor, category_id, '
      'transaction_date, description, usd_try_rate, eur_try_rate, xau_try_rate, '
      'rate_snapshot_at, created_at, updated_at) '
      'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
    );

    final snapshotAt = _epoch(DateTime(2026, 8, 20, 9, 30));
    for (var i = 1; i <= 10; i++) {
      insert.execute([
        i,
        'income',
        'tryLira',
        12500000 + i,
        1,
        _epoch(DateTime(2026, 8, i)),
        'Maaş $i',
        41.2536,
        48.1120,
        5842.30,
        snapshotAt,
        snapshotAt,
        snapshotAt,
      ]);
    }
    for (var i = 11; i <= 30; i++) {
      insert.execute([
        i,
        'expense',
        i.isEven ? 'tryLira' : 'usd',
        10000 * i,
        7,
        _epoch(DateTime(2026, 8, i - 10)),
        null,
        41.2536,
        48.1120,
        5842.30,
        snapshotAt,
        snapshotAt,
        snapshotAt,
      ]);
    }
    for (var i = 31; i <= 35; i++) {
      insert.execute([
        i,
        'saving',
        'xau',
        500,
        16,
        _epoch(DateTime(2026, 7, i - 30)),
        'Altın',
        41.2536,
        48.1120,
        5842.30,
        snapshotAt,
        snapshotAt,
        snapshotAt,
      ]);
    }
    insert.close();

    raw.execute(
      'INSERT INTO exchange_rates (usd_try_rate, eur_try_rate, xau_try_rate, '
      'fetched_at, source) VALUES (41.2536, 48.1120, 5842.30, ?, ?)',
      [_epoch(DateTime(2026, 8, 28, 8, 17)), 'truncgil'],
    );
    raw.close();
  }

  test('upgrading v2 to v3 keeps every existing row untouched', () async {
    seedV2Database();

    final database = AppDatabase(NativeDatabase(dbFile));
    addTearDown(database.close);

    final repository = TransactionRepository(database);
    final stored = await repository.watchAll().first;

    expect(await repository.count(), 35);
    expect(stored, hasLength(35));

    final income = stored.firstWhere((t) => t.id == 1);
    expect(income.type, TransactionType.income);
    expect(income.currency, Currency.tryLira);
    expect(income.amountMinor, 12500001);
    expect(income.categoryId, 1);
    expect(income.description, 'Maaş 1');
    expect(income.transactionDate, DateTime(2026, 8, 1));
    expect(income.rates?.usdTry, 41.2536);
    expect(income.rates?.eurTry, 48.1120);
    expect(income.rates?.xauTry, 5842.30);
    expect(income.rateSnapshotAt, DateTime(2026, 8, 20, 9, 30));

    // Columns added by v3 default to null on historical rows.
    expect(income.subcategoryId, isNull);
    expect(income.debtOperation, isNull);

    final gold = stored.firstWhere((t) => t.id == 31);
    expect(gold.type, TransactionType.saving);
    expect(gold.currency, Currency.xau);
    expect(gold.amount, 5);

    final foreign = stored.firstWhere((t) => t.id == 11);
    expect(foreign.currency, Currency.usd);
    expect(foreign.amountMinor, 110000);
  });

  test('the cached quote and its timestamp survive the upgrade', () async {
    seedV2Database();

    final database = AppDatabase(NativeDatabase(dbFile));
    addTearDown(database.close);

    final rows = await database.select(database.exchangeRateCache).get();

    expect(rows, hasLength(1));
    expect(rows.single.usdTryRate, 41.2536);
    expect(rows.single.fetchedAt, DateTime(2026, 8, 28, 8, 17));
    expect(rows.single.source, 'truncgil');
    expect(rows.single.sourceUpdatedAt, isNull);
  });

  test('the upgraded database accepts the new Sprint 3 columns', () async {
    seedV2Database();

    final database = AppDatabase(NativeDatabase(dbFile));
    addTearDown(database.close);

    await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion.insert(
            type: TransactionType.expense,
            currency: Currency.xau,
            amountMinor: 10500,
            categoryId: 118,
            subcategoryId: const Value(11802),
            debtOperation: const Value(DebtOperation.add),
            transactionDate: DateTime(2026, 9, 1),
            createdAt: DateTime(2026, 9, 1),
            updatedAt: DateTime(2026, 9, 1),
          ),
        );

    final repository = TransactionRepository(database);
    expect(await repository.count(), 36);

    final stored = await repository.watchAll().first;
    final debtRow = stored.firstWhere((t) => t.subcategoryId == 11802);
    expect(debtRow.debtOperation, DebtOperation.add);
    expect(debtRow.amount, 105);
  });

  test('financial totals stay correct on migrated legacy rows', () async {
    seedV2Database();

    final database = AppDatabase(NativeDatabase(dbFile));
    addTearDown(database.close);

    final transactions = await TransactionRepository(database).watchAll().first;
    final summary = FinancialSummaryService.build(
      transactions: transactions,
      debts: DebtService.buildAll(transactions),
      currency: Currency.tryLira,
      currentRates: null,
      now: DateTime(2026, 9, 1),
    );

    // 10 income rows of 125000,0x TRY.
    expect(summary.totalIncome, closeTo(1250000.55, 0.01));

    // 5 saving rows of 5 gram gold at the stored snapshot rate.
    expect(summary.manualAssets, closeTo(5 * 5 * 5842.30, 0.01));

    // Legacy rows carry no debt movement, so nothing is filtered out.
    expect(summary.totalDebt, 0);
    expect(
      summary.netSavings,
      closeTo(summary.totalIncome - summary.totalExpense, 0.01),
    );
    expect(
      summary.totalAssets,
      closeTo(summary.netSavings + summary.manualAssets, 0.01),
    );
  });

  test('reopening the file keeps the data and stays on v3', () async {
    seedV2Database();

    final first = AppDatabase(NativeDatabase(dbFile));
    expect(await TransactionRepository(first).count(), 35);
    await first.close();

    final second = AppDatabase(NativeDatabase(dbFile));
    addTearDown(second.close);
    expect(await TransactionRepository(second).count(), 35);

    final raw = sqlite3.open(dbFile.path);
    addTearDown(raw.close);
    expect(raw.select('PRAGMA user_version').first.values.first, 3);
  });
}
