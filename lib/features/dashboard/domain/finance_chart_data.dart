import 'dart:collection';
import 'dart:math' as math;

import '../../../shared/models/currency.dart';
import '../../../shared/models/transaction_type.dart';
import '../../transactions/domain/transaction.dart';

/// One day on the trend chart, holding cumulative totals up to that day.
class ChartPoint {
  const ChartPoint({
    required this.date,
    required this.income,
    required this.expense,
    required this.saving,
  });

  final DateTime date;
  final double income;
  final double expense;
  final double saving;
}

class FinanceChartData {
  const FinanceChartData(this.points);

  final List<ChartPoint> points;

  static const int minimumTransactions = 10;

  bool get isEmpty => points.isEmpty;

  DateTime get firstDate => points.first.date;

  /// X axis is measured in days elapsed since [firstDate].
  double xOf(ChartPoint point) =>
      point.date.difference(firstDate).inDays.toDouble();

  double get maxX => points.isEmpty ? 0 : xOf(points.last);

  double get minY => 0;

  double get maxY {
    var value = 0.0;
    for (final point in points) {
      value = math.max(value, math.max(point.income, point.expense));
      value = math.max(value, point.saving);
    }
    return value;
  }

  /// Cumulative income / expense / saving per calendar day, converted with
  /// each transaction's own snapshot.
  factory FinanceChartData.from({
    required List<Transaction> transactions,
    required Currency currency,
  }) {
    if (transactions.isEmpty) return const FinanceChartData([]);

    final buckets = SplayTreeMap<DateTime, _DayTotals>();
    for (final transaction in transactions) {
      final date = transaction.transactionDate;
      final day = DateTime(date.year, date.month, date.day);
      final totals = buckets.putIfAbsent(day, _DayTotals.new);
      final amount = transaction.amountIn(currency) ?? 0;

      switch (transaction.type) {
        case TransactionType.income:
          totals.income += amount;
        case TransactionType.expense:
          // Debt movements are not consumption, so they stay off the line.
          if (transaction.countsAsSpending) totals.expense += amount;
        case TransactionType.saving:
          totals.saving += amount;
      }
    }

    var income = 0.0;
    var expense = 0.0;
    var saving = 0.0;
    final points = <ChartPoint>[];
    for (final entry in buckets.entries) {
      income += entry.value.income;
      expense += entry.value.expense;
      saving += entry.value.saving;
      points.add(
        ChartPoint(
          date: entry.key,
          income: income,
          expense: expense,
          saving: saving,
        ),
      );
    }

    return FinanceChartData(points);
  }
}

class _DayTotals {
  double income = 0;
  double expense = 0;
  double saving = 0;
}
