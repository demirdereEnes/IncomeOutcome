import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/features/dashboard/domain/dashboard_summary.dart';
import 'package:income_outcome/features/dashboard/domain/finance_chart_data.dart';
import 'package:income_outcome/features/rates/domain/exchange_rates.dart';
import 'package:income_outcome/features/transactions/domain/transaction.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';

final _snapshot = ExchangeRates(
  usdTry: 41.2536,
  eurTry: 48.1120,
  xauTry: 5842.30,
  fetchedAt: DateTime(2026, 8, 29, 9, 30),
  source: 'test',
);

Transaction _tx({
  int id = 1,
  required TransactionType type,
  required Currency currency,
  required double amount,
  ExchangeRates? rates,
  DateTime? date,
}) {
  final when = date ?? DateTime(2026, 8, 29);
  return Transaction(
    id: id,
    type: type,
    currency: currency,
    amountMinor: (amount * 100).round(),
    categoryId: 1,
    transactionDate: when,
    rates: rates ?? _snapshot,
    rateSnapshotAt: (rates ?? _snapshot).fetchedAt,
    createdAt: when,
    updatedAt: when,
  );
}

void main() {
  group('rate snapshot conversion', () {
    test('TRY entry keeps its amount and needs no conversion', () {
      final transaction = _tx(
        type: TransactionType.income,
        currency: Currency.tryLira,
        amount: 125000,
      );

      expect(transaction.tryAmountSnapshot, closeTo(125000, 0.001));
    });

    test('100 USD at 41,2536 is 4.125,36 TRY', () {
      final transaction = _tx(
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 100,
      );

      expect(transaction.tryAmountSnapshot, closeTo(4125.36, 0.001));
    });

    test('1.000 EUR at 48,1120 is 48.112,00 TRY', () {
      final transaction = _tx(
        type: TransactionType.expense,
        currency: Currency.eur,
        amount: 1000,
      );

      expect(transaction.tryAmountSnapshot, closeTo(48112.0, 0.001));
    });

    test('5 gram gold at 5.842,30 is 29.211,50 TRY', () {
      final transaction = _tx(
        type: TransactionType.saving,
        currency: Currency.xau,
        amount: 5,
      );

      expect(transaction.tryAmountSnapshot, closeTo(29211.50, 0.001));
    });

    test('historical value ignores later rate movements', () {
      final old = _tx(
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 100,
      );

      // Today's rate jumps to 45,00 - the stored entry must not follow.
      final today = ExchangeRates(
        usdTry: 45,
        eurTry: 52,
        xauTry: 6400,
        fetchedAt: DateTime(2026, 9, 30),
      );
      final fresh = _tx(
        id: 2,
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 100,
        rates: today,
      );

      expect(old.tryAmountSnapshot, closeTo(4125.36, 0.001));
      expect(fresh.tryAmountSnapshot, closeTo(4500.0, 0.001));
    });

    test('a TRY entry saved without rates cannot be converted', () {
      final transaction = Transaction(
        id: 9,
        type: TransactionType.income,
        currency: Currency.tryLira,
        amountMinor: 500000,
        categoryId: 1,
        transactionDate: DateTime(2026, 8, 29),
        createdAt: DateTime(2026, 8, 29),
        updatedAt: DateTime(2026, 8, 29),
      );

      expect(transaction.amountIn(Currency.tryLira), 5000);
      expect(transaction.amountIn(Currency.usd), isNull);
    });
  });

  group('dashboard summary', () {
    final transactions = [
      _tx(
        id: 1,
        type: TransactionType.income,
        currency: Currency.tryLira,
        amount: 125000,
      ),
      _tx(
        id: 2,
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 60,
      ),
      _tx(
        id: 3,
        type: TransactionType.saving,
        currency: Currency.xau,
        amount: 5,
      ),
    ];

    test('savings come from saving entries, not income minus expense', () {
      final summary = DashboardSummary.from(
        transactions: transactions,
        currency: Currency.tryLira,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalIncome, closeTo(125000, 0.01));
      expect(summary.totalExpense, closeTo(2475.216, 0.01));
      expect(summary.totalSaving, closeTo(29211.50, 0.01));
    });

    test('switching the display currency re-converts every entry', () {
      final summary = DashboardSummary.from(
        transactions: transactions,
        currency: Currency.usd,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalIncome, closeTo(125000 / 41.2536, 0.01));
      expect(summary.totalExpense, closeTo(60, 0.01));
      expect(summary.totalSaving, closeTo(29211.50 / 41.2536, 0.01));
    });

    test('current month expense only counts this calendar month', () {
      final summary = DashboardSummary.from(
        transactions: [
          _tx(
            id: 1,
            type: TransactionType.expense,
            currency: Currency.tryLira,
            amount: 1000,
            date: DateTime(2026, 8, 5),
          ),
          _tx(
            id: 2,
            type: TransactionType.expense,
            currency: Currency.tryLira,
            amount: 4000,
            date: DateTime(2026, 7, 5),
          ),
        ],
        currency: Currency.tryLira,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalExpense, closeTo(5000, 0.01));
      expect(summary.currentMonthExpense, closeTo(1000, 0.01));
    });
  });

  group('chart aggregation', () {
    test('series are cumulative per day', () {
      final data = FinanceChartData.from(
        transactions: [
          _tx(
            id: 1,
            type: TransactionType.income,
            currency: Currency.tryLira,
            amount: 100000,
            date: DateTime(2026, 8, 1),
          ),
          _tx(
            id: 2,
            type: TransactionType.expense,
            currency: Currency.tryLira,
            amount: 5000,
            date: DateTime(2026, 8, 2),
          ),
          _tx(
            id: 3,
            type: TransactionType.saving,
            currency: Currency.tryLira,
            amount: 20000,
            date: DateTime(2026, 8, 5),
          ),
          _tx(
            id: 4,
            type: TransactionType.expense,
            currency: Currency.tryLira,
            amount: 10000,
            date: DateTime(2026, 8, 5),
          ),
        ],
        currency: Currency.tryLira,
      );

      expect(data.points.length, 3);
      expect(data.points.last.income, closeTo(100000, 0.01));
      expect(data.points.last.expense, closeTo(15000, 0.01));
      expect(data.points.last.saving, closeTo(20000, 0.01));
      expect(data.xOf(data.points.last), 4);
    });
  });
}
