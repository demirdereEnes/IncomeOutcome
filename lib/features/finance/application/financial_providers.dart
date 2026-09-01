import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/application/dashboard_providers.dart';
import '../../rates/application/rates_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../domain/debt.dart';
import '../domain/financial_summary.dart';

/// Debt balances derived from every debt movement in the database.
final debtsProvider = Provider<List<Debt>>(
  (ref) => DebtService.buildAll(ref.watch(transactionListProvider)),
);

final activeDebtsProvider = Provider<List<Debt>>(
  (ref) => ref.watch(debtsProvider).where((debt) => debt.isActive).toList(),
);

/// Single source of truth for every dashboard figure.
final financialSummaryProvider = Provider<FinancialSummary>((ref) {
  return FinancialSummaryService.build(
    transactions: ref.watch(transactionListProvider),
    debts: ref.watch(debtsProvider),
    currency: ref.watch(selectedCurrencyProvider),
    currentRates: ref.watch(currentExchangeRatesProvider),
    now: DateTime.now(),
  );
});
