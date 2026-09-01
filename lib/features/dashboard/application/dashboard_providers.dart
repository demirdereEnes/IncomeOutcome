import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/currency.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/finance_chart_data.dart';

class SelectedCurrencyNotifier extends Notifier<Currency> {
  @override
  Currency build() => Currency.tryLira;

  void select(Currency currency) => state = currency;
}

/// Display-only filter. Switching it never triggers a rate fetch.
final selectedCurrencyProvider =
    NotifierProvider<SelectedCurrencyNotifier, Currency>(
      SelectedCurrencyNotifier.new,
    );

final chartDataProvider = Provider<FinanceChartData>((ref) {
  return FinanceChartData.from(
    transactions: ref.watch(transactionListProvider),
    currency: ref.watch(selectedCurrencyProvider),
  );
});

/// Most recent entries shown directly on the dashboard.
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionListProvider).take(10).toList(growable: false);
});
