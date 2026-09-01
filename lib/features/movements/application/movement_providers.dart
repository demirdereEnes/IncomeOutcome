import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/transaction_type.dart';
import '../../categories/domain/category.dart';
import '../../categories/domain/category_catalog.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/movement_filter.dart';
import '../domain/spending_breakdown.dart';

class MovementFilterNotifier extends Notifier<MovementFilter> {
  @override
  MovementFilter build() => const MovementFilter();

  void setPeriod(MovementPeriod period) =>
      state = state.copyWith(period: period);

  /// Changing the type invalidates any category drill-down below it.
  void setType(TransactionType? type) => state = state.copyWith(
    type: type,
    categoryId: null,
    subcategoryId: null,
  );

  void setCategory(int? categoryId) =>
      state = state.copyWith(categoryId: categoryId, subcategoryId: null);

  void setSubcategory(int? subcategoryId) =>
      state = state.copyWith(subcategoryId: subcategoryId);
}

final movementFilterProvider =
    NotifierProvider<MovementFilterNotifier, MovementFilter>(
      MovementFilterNotifier.new,
    );

/// Everything the Hareketler screen renders comes from this one list.
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref
      .watch(movementFilterProvider)
      .apply(ref.watch(transactionListProvider), DateTime.now());
});

/// Categories offered as chips: those actually reachable for the selected
/// type, plus any legacy category the user still has data in.
final filterCategoriesProvider = Provider<List<Category>>((ref) {
  final filter = ref.watch(movementFilterProvider);
  final type = filter.type;
  if (type == null) return const [];

  final usedIds = <int>{
    for (final transaction in ref.watch(transactionListProvider))
      if (transaction.type == type) transaction.categoryId,
  };

  final categories =
      categoryCatalog
          .where((c) => c.type == type && (!c.isLegacy || usedIds.contains(c.id)))
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return categories;
});

final spendingBreakdownProvider = Provider<SpendingBreakdown>((ref) {
  final filter = ref.watch(movementFilterProvider);
  return SpendingBreakdown.from(
    transactions: ref.watch(filteredTransactionsProvider),
    currency: ref.watch(selectedCurrencyProvider),
    categoryId: filter.categoryId,
    includeDebtMovements: filter.categoryId == CategoryIds.debtAndFinance,
  );
});
