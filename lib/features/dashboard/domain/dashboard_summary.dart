import '../../../shared/models/currency.dart';
import '../../../shared/models/transaction_type.dart';
import '../../transactions/domain/transaction.dart';

/// Headline figures, expressed in the selected currency.
///
/// Every entry is converted with its own historical snapshot, so these totals
/// do not move when today's rates change.
class DashboardSummary {
  const DashboardSummary({
    required this.currency,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSaving,
    required this.currentMonthExpense,
    required this.transactionCount,
  });

  final Currency currency;
  final double totalIncome;
  final double totalExpense;

  /// Sum of saving entries - deliberately not `income - expense`.
  final double totalSaving;

  final double currentMonthExpense;
  final int transactionCount;

  bool get isEmpty => transactionCount == 0;

  factory DashboardSummary.from({
    required List<Transaction> transactions,
    required Currency currency,
    required DateTime now,
  }) {
    var income = 0.0;
    var expense = 0.0;
    var saving = 0.0;
    var monthExpense = 0.0;

    for (final transaction in transactions) {
      final amount = transaction.amountIn(currency) ?? 0;
      switch (transaction.type) {
        case TransactionType.income:
          income += amount;
        case TransactionType.saving:
          saving += amount;
        case TransactionType.expense:
          expense += amount;
          final inCurrentMonth =
              transaction.transactionDate.year == now.year &&
              transaction.transactionDate.month == now.month;
          if (inCurrentMonth) monthExpense += amount;
      }
    }

    return DashboardSummary(
      currency: currency,
      totalIncome: income,
      totalExpense: expense,
      totalSaving: saving,
      currentMonthExpense: monthExpense,
      transactionCount: transactions.length,
    );
  }
}
