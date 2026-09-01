import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/features/movements/domain/movement_filter.dart';
import 'package:income_outcome/features/movements/domain/spending_breakdown.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/debt_operation.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';

import 'support/test_data.dart';

void main() {
  setUp(resetTestIds);

  final now = DateTime(2026, 9, 1);
  final transactions = [
    tx(
      type: TransactionType.expense,
      amount: 3500,
      categoryId: 112,
      subcategoryId: 11200,
      date: DateTime(2026, 8, 25),
    ),
    tx(
      type: TransactionType.expense,
      amount: 2300,
      categoryId: 112,
      subcategoryId: 11205,
      date: DateTime(2026, 7, 20),
    ),
    tx(
      type: TransactionType.expense,
      amount: 4200,
      categoryId: 113,
      subcategoryId: 11300,
      date: DateTime(2026, 5, 10),
    ),
    tx(
      type: TransactionType.income,
      amount: 125000,
      categoryId: 100,
      date: DateTime(2026, 8, 28),
    ),
    tx(
      type: TransactionType.expense,
      amount: 900,
      categoryId: 111,
      subcategoryId: 11100,
      date: DateTime(2025, 12, 1),
    ),
  ];

  group('period filter', () {
    test('1 month keeps only the last month', () {
      const filter = MovementFilter();
      expect(filter.period, MovementPeriod.oneMonth);
      expect(filter.apply(transactions, now), hasLength(2));
    });

    test('3 months widens the window', () {
      const filter = MovementFilter(period: MovementPeriod.threeMonths);
      expect(filter.apply(transactions, now), hasLength(3));
    });

    test('6 months widens it further', () {
      const filter = MovementFilter(period: MovementPeriod.sixMonths);
      expect(filter.apply(transactions, now), hasLength(4));
    });

    test('all time keeps everything', () {
      const filter = MovementFilter(period: MovementPeriod.all);
      expect(filter.apply(transactions, now), hasLength(5));
    });
  });

  group('type, category and subcategory filters', () {
    test('type narrows to one kind', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
      );
      expect(filter.apply(transactions, now), hasLength(4));
    });

    test('category narrows further', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
        categoryId: 112,
      );
      expect(filter.apply(transactions, now), hasLength(2));
    });

    test('subcategory narrows to a single entry', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
        categoryId: 112,
        subcategoryId: 11200,
      );
      final result = filter.apply(transactions, now);
      expect(result, hasLength(1));
      expect(result.single.amount, 3500);
    });

    test('changing the type clears the category drill-down', () {
      const filter = MovementFilter(
        type: TransactionType.expense,
        categoryId: 112,
        subcategoryId: 11200,
      );
      final cleared = filter.copyWith(
        type: TransactionType.income,
        categoryId: null,
        subcategoryId: null,
      );

      expect(cleared.categoryId, isNull);
      expect(cleared.subcategoryId, isNull);
    });
  });

  group('donut breakdown', () {
    test('groups by category with real percentages', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
      );
      final breakdown = SpendingBreakdown.from(
        transactions: filter.apply(transactions, now),
        currency: Currency.tryLira,
      );

      expect(breakdown.total, closeTo(10900, 0.01));
      expect(breakdown.isSubcategoryLevel, isFalse);
      expect(breakdown.slices.first.label, 'Araç');
      expect(breakdown.slices.first.amount, closeTo(5800, 0.01));
      expect(breakdown.slices.first.percentage, closeTo(53.211, 0.01));
    });

    test('drilling into a category switches to subcategories', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
        categoryId: 112,
      );
      final breakdown = SpendingBreakdown.from(
        transactions: filter.apply(transactions, now),
        currency: Currency.tryLira,
        categoryId: 112,
      );

      expect(breakdown.isSubcategoryLevel, isTrue);
      expect(breakdown.slices.map((s) => s.label), ['Akaryakıt', 'MTV']);
      expect(breakdown.slices.first.amount, closeTo(3500, 0.01));
    });

    test('an empty filter result produces an empty breakdown', () {
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.saving,
      );
      final breakdown = SpendingBreakdown.from(
        transactions: filter.apply(transactions, now),
        currency: Currency.tryLira,
      );

      expect(breakdown.isEmpty, isTrue);
    });

    test('debt movements stay out of the spending ring', () {
      final withDebt = [
        ...transactions,
        tx(
          type: TransactionType.expense,
          amount: 500000,
          categoryId: 118,
          subcategoryId: 11802,
          debtOperation: DebtOperation.add,
          date: DateTime(2026, 8, 20),
        ),
      ];
      const filter = MovementFilter(
        period: MovementPeriod.all,
        type: TransactionType.expense,
      );

      final spending = SpendingBreakdown.from(
        transactions: filter.apply(withDebt, now),
        currency: Currency.tryLira,
      );
      expect(spending.total, closeTo(10900, 0.01));
      expect(spending.slices.any((s) => s.label == 'Borç & Finans'), isFalse);

      final debtView = SpendingBreakdown.from(
        transactions: filter
            .copyWith(categoryId: 118)
            .apply(withDebt, now),
        currency: Currency.tryLira,
        categoryId: 118,
        includeDebtMovements: true,
      );
      expect(debtView.total, closeTo(500000, 0.01));
      expect(debtView.slices.single.label, 'Altın Borcu');
    });
  });
}
