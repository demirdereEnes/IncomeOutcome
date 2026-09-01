import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/features/finance/domain/debt.dart';
import 'package:income_outcome/features/finance/domain/financial_summary.dart';
import 'package:income_outcome/features/rates/domain/exchange_rates.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/debt_operation.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';

import 'support/test_data.dart';

void main() {
  setUp(resetTestIds);

  group('net savings', () {
    test('income only', () {
      final summary = FinancialSummaryService.build(
        transactions: [tx(type: TransactionType.income, amount: 125000)],
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalIncome, closeTo(125000, 0.01));
      expect(summary.totalExpense, 0);
      expect(summary.netSavings, closeTo(125000, 0.01));
    });

    test('expense only', () {
      final summary = FinancialSummaryService.build(
        transactions: [tx(type: TransactionType.expense, amount: 40000)],
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalExpense, closeTo(40000, 0.01));
      expect(summary.netSavings, closeTo(-40000, 0.01));
    });

    test('net savings is income minus expense and may go negative', () {
      final summary = FinancialSummaryService.build(
        transactions: [
          tx(type: TransactionType.income, amount: 100000),
          tx(type: TransactionType.expense, amount: 125000),
        ],
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.netSavings, closeTo(-25000, 0.01));
    });

    test('manual savings are not folded into net savings', () {
      final summary = FinancialSummaryService.build(
        transactions: [
          tx(type: TransactionType.income, amount: 500000),
          tx(type: TransactionType.expense, amount: 350000),
          tx(type: TransactionType.saving, amount: 100000),
        ],
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.netSavings, closeTo(150000, 0.01));
      expect(summary.manualAssets, closeTo(100000, 0.01));
      expect(summary.totalAssets, closeTo(250000, 0.01));
    });
  });

  group('net worth', () {
    test('assets minus debt, matching the worked example', () {
      final transactions = [
        tx(type: TransactionType.income, amount: 500000),
        tx(type: TransactionType.expense, amount: 350000),
        tx(type: TransactionType.saving, amount: 100000),
        tx(
          type: TransactionType.expense,
          amount: 60000,
          categoryId: 118,
          subcategoryId: 11804,
          debtOperation: DebtOperation.add,
        ),
      ];
      final debts = DebtService.buildAll(transactions);

      final summary = FinancialSummaryService.build(
        transactions: transactions,
        debts: debts,
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalAssets, closeTo(250000, 0.01));
      expect(summary.totalDebt, closeTo(60000, 0.01));
      expect(summary.netWorth, closeTo(190000, 0.01));
    });

    test('rising expenses lower net worth', () {
      final transactions = [
        tx(type: TransactionType.income, amount: 500000),
        tx(type: TransactionType.expense, amount: 400000),
        tx(type: TransactionType.saving, amount: 100000),
      ];

      final summary = FinancialSummaryService.build(
        transactions: transactions,
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.netSavings, closeTo(100000, 0.01));
      expect(summary.netWorth, closeTo(200000, 0.01));
    });
  });

  group('debt', () {
    test('adding then paying reduces the balance in the original currency', () {
      final transactions = [
        tx(
          type: TransactionType.expense,
          currency: Currency.xau,
          amount: 105,
          categoryId: 118,
          subcategoryId: 11802,
          debtOperation: DebtOperation.add,
        ),
        tx(
          type: TransactionType.expense,
          currency: Currency.xau,
          amount: 20,
          categoryId: 118,
          subcategoryId: 11802,
          debtOperation: DebtOperation.pay,
        ),
      ];

      final debts = DebtService.buildAll(transactions);

      expect(debts, hasLength(1));
      expect(debts.single.name, 'Altın Borcu');
      expect(debts.single.currency, Currency.xau);
      expect(debts.single.originalAmount, 105);
      expect(debts.single.remainingAmount, 85);
      expect(debts.single.isActive, isTrue);
    });

    test('debt movements never reach Total Expense', () {
      final transactions = [
        tx(type: TransactionType.expense, amount: 10000, categoryId: 113),
        tx(
          type: TransactionType.expense,
          amount: 10000,
          categoryId: 118,
          subcategoryId: 11800,
          debtOperation: DebtOperation.pay,
        ),
      ];

      final summary = FinancialSummaryService.build(
        transactions: transactions,
        debts: DebtService.buildAll(transactions),
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalExpense, closeTo(10000, 0.01));
    });

    test('gold debt is valued with the current rate, not the snapshot', () {
      final oldRates = ExchangeRates(
        usdTry: 41.2536,
        eurTry: 48.1120,
        xauTry: 5842.30,
        fetchedAt: DateTime(2026, 8, 1),
      );
      final transactions = [
        tx(
          type: TransactionType.expense,
          currency: Currency.xau,
          amount: 100,
          categoryId: 118,
          subcategoryId: 11802,
          debtOperation: DebtOperation.add,
          rates: oldRates,
        ),
      ];
      final debts = DebtService.buildAll(transactions);

      final today = ExchangeRates(
        usdTry: 48.2613,
        eurTry: 55.9825,
        xauTry: 6855.63,
        fetchedAt: DateTime(2026, 9, 1),
      );

      expect(
        DebtService.totalIn(
          debts: debts,
          currency: Currency.tryLira,
          rates: today,
        ),
        closeTo(685563, 1),
      );
      expect(debts.single.remainingAmount, 100);
    });

    test('a fully repaid debt drops out of the total', () {
      final transactions = [
        tx(
          type: TransactionType.expense,
          amount: 5000,
          categoryId: 118,
          subcategoryId: 11800,
          debtOperation: DebtOperation.add,
        ),
        tx(
          type: TransactionType.expense,
          amount: 5000,
          categoryId: 118,
          subcategoryId: 11800,
          debtOperation: DebtOperation.pay,
        ),
      ];
      final debts = DebtService.buildAll(transactions);

      expect(debts.single.isActive, isFalse);
      expect(
        DebtService.totalIn(
          debts: debts,
          currency: Currency.tryLira,
          rates: testRates,
        ),
        0,
      );
    });
  });

  group('currency and month scoping', () {
    test('totals re-convert with each entry own snapshot', () {
      final summary = FinancialSummaryService.build(
        transactions: [
          tx(type: TransactionType.income, amount: 125000),
          tx(
            type: TransactionType.expense,
            currency: Currency.usd,
            amount: 60,
          ),
        ],
        debts: const [],
        currency: Currency.usd,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalIncome, closeTo(125000 / 41.2536, 0.01));
      expect(summary.totalExpense, closeTo(60, 0.01));
    });

    test('current month expense ignores older months', () {
      final summary = FinancialSummaryService.build(
        transactions: [
          tx(
            type: TransactionType.expense,
            amount: 1000,
            date: DateTime(2026, 8, 5),
          ),
          tx(
            type: TransactionType.expense,
            amount: 4000,
            date: DateTime(2026, 7, 5),
          ),
        ],
        debts: const [],
        currency: Currency.tryLira,
        currentRates: testRates,
        now: DateTime(2026, 8, 29),
      );

      expect(summary.totalExpense, closeTo(5000, 0.01));
      expect(summary.currentMonthExpense, closeTo(1000, 0.01));
    });
  });
}
