import '../../../shared/models/currency.dart';
import '../../../shared/models/transaction_type.dart';
import '../../rates/domain/exchange_rates.dart';
import '../../transactions/domain/transaction.dart';
import 'debt.dart';

/// Every headline figure the app shows, in one place.
///
/// Two conversion rules live side by side and must not be mixed:
/// * income / expense / manual assets come from each transaction's own
///   historical snapshot;
/// * debt is valued with the current market rate.
class FinancialSummary {
  const FinancialSummary({
    required this.currency,
    required this.totalIncome,
    required this.totalExpense,
    required this.manualAssets,
    required this.totalDebt,
    required this.currentMonthExpense,
    required this.transactionCount,
  });

  const FinancialSummary.empty(this.currency)
    : totalIncome = 0,
      totalExpense = 0,
      manualAssets = 0,
      totalDebt = 0,
      currentMonthExpense = 0,
      transactionCount = 0;

  final Currency currency;
  final double totalIncome;

  /// Consumption only. Debt movements are excluded so a repayment is not
  /// counted a second time.
  final double totalExpense;

  /// Sum of the manually recorded "Birikim" entries.
  final double manualAssets;

  final double totalDebt;
  final double currentMonthExpense;
  final int transactionCount;

  double get netSavings => totalIncome - totalExpense;

  double get totalAssets => netSavings + manualAssets;

  double get netWorth => totalAssets - totalDebt;

  bool get isEmpty => transactionCount == 0;
}

abstract final class FinancialSummaryService {
  static FinancialSummary build({
    required List<Transaction> transactions,
    required List<Debt> debts,
    required Currency currency,
    required ExchangeRates? currentRates,
    required DateTime now,
  }) {
    return FinancialSummary(
      currency: currency,
      totalIncome: calculateTotalIncome(transactions, currency),
      totalExpense: calculateTotalExpense(transactions, currency),
      manualAssets: calculateManualAssets(transactions, currency),
      totalDebt: calculateTotalDebt(debts, currency, currentRates),
      currentMonthExpense: calculateCurrentMonthExpense(
        transactions,
        currency,
        now,
      ),
      transactionCount: transactions.length,
    );
  }

  static double calculateTotalIncome(
    List<Transaction> transactions,
    Currency currency,
  ) => _sum(
    transactions.where((t) => t.type == TransactionType.income),
    currency,
  );

  static double calculateTotalExpense(
    List<Transaction> transactions,
    Currency currency,
  ) => _sum(transactions.where((t) => t.countsAsSpending), currency);

  static double calculateManualAssets(
    List<Transaction> transactions,
    Currency currency,
  ) => _sum(
    transactions.where((t) => t.type == TransactionType.saving),
    currency,
  );

  static double calculateCurrentMonthExpense(
    List<Transaction> transactions,
    Currency currency,
    DateTime now,
  ) => _sum(
    transactions.where(
      (t) =>
          t.countsAsSpending &&
          t.transactionDate.year == now.year &&
          t.transactionDate.month == now.month,
    ),
    currency,
  );

  static double calculateNetSavings(
    List<Transaction> transactions,
    Currency currency,
  ) =>
      calculateTotalIncome(transactions, currency) -
      calculateTotalExpense(transactions, currency);

  static double calculateTotalAssets(
    List<Transaction> transactions,
    Currency currency,
  ) =>
      calculateNetSavings(transactions, currency) +
      calculateManualAssets(transactions, currency);

  static double calculateTotalDebt(
    List<Debt> debts,
    Currency currency,
    ExchangeRates? currentRates,
  ) => DebtService.totalIn(
    debts: debts,
    currency: currency,
    rates: currentRates,
  );

  static double calculateNetWorth({
    required List<Transaction> transactions,
    required List<Debt> debts,
    required Currency currency,
    required ExchangeRates? currentRates,
  }) =>
      calculateTotalAssets(transactions, currency) -
      calculateTotalDebt(debts, currency, currentRates);

  static double _sum(Iterable<Transaction> transactions, Currency currency) {
    var total = 0.0;
    for (final transaction in transactions) {
      total += transaction.amountIn(currency) ?? 0;
    }
    return total;
  }
}
