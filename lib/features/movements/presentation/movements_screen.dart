import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/segmented_pills.dart';
import '../../../shared/widgets/transaction_list_item.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category_catalog.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../application/movement_providers.dart';
import '../domain/movement_filter.dart';
import 'widgets/spending_donut_card.dart';

/// Hareketler: period -> type -> category -> subcategory, with the donut and
/// the list both driven by that single filter.
class MovementsScreen extends ConsumerWidget {
  const MovementsScreen({super.key, required this.onAddTransaction});

  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(movementFilterProvider);
    final notifier = ref.read(movementFilterProvider.notifier);
    final transactions = ref.watch(filteredTransactionsProvider);
    final currency = ref.watch(selectedCurrencyProvider);
    final hasAnyData = ref.watch(transactionListProvider).isNotEmpty;

    if (!hasAnyData) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Center(
          child: EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Henüz hareket yok',
            message: 'Eklediğin gelir, gider ve birikimler burada listelenir.',
            action: ElevatedButton(
              onPressed: onAddTransaction,
              child: const Text('İlk İşlemini Ekle'),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxxl * 3,
      ),
      children: [
        SegmentedPills<MovementPeriod>(
          values: MovementPeriod.values,
          selected: filter.period,
          labelOf: (period) => period.label,
          onChanged: notifier.setPeriod,
        ),
        const SizedBox(height: AppSpacing.md),
        SegmentedPills<TransactionType?>(
          values: const [null, ...TransactionType.values],
          selected: filter.type,
          labelOf: (type) => type?.label ?? 'Tümü',
          onChanged: notifier.setType,
        ),
        if (filter.type != null) ...[
          const SizedBox(height: AppSpacing.md),
          _CategoryChips(filter: filter),
        ],
        if (filter.hasCategory) ...[
          const SizedBox(height: AppSpacing.sm),
          _SubcategoryChips(filter: filter),
        ],
        const SizedBox(height: AppSpacing.xl),
        SpendingDonutCard(
          breakdown: ref.watch(spendingBreakdownProvider),
          currency: currency,
          title: _breakdownTitle(filter),
          onSliceTap: filter.hasCategory ? null : notifier.setCategory,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: 'Hareketler (${transactions.length})'),
        const SizedBox(height: AppSpacing.sm),
        if (transactions.isEmpty)
          const AppCard(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: EmptyState(
              icon: Icons.filter_alt_off_outlined,
              title: 'Bu filtre için henüz işlem yok',
              message: 'Farklı bir dönem ya da kategori seçmeyi dene.',
            ),
          )
        else
          _MovementList(transactions: transactions),
        if (transactions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Bir işlemi silmek için sola kaydır.',
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
        ],
      ],
    );
  }

  String _breakdownTitle(MovementFilter filter) {
    if (filter.hasCategory) {
      final name = categoriesById[filter.categoryId]?.name ?? 'Kategori';
      return '$name Dağılımı';
    }
    return switch (filter.type) {
      TransactionType.income => 'Gelir Dağılımı',
      TransactionType.expense => 'Gider Dağılımı',
      TransactionType.saving => 'Birikim Dağılımı',
      null => 'Kategori Dağılımı',
    };
  }
}

class _CategoryChips extends ConsumerWidget {
  const _CategoryChips({required this.filter});

  final MovementFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(filterCategoriesProvider);
    if (categories.isEmpty) return const SizedBox.shrink();

    return FilterChipsBar(
      selectedId: filter.categoryId,
      onSelected: ref.read(movementFilterProvider.notifier).setCategory,
      items: [
        const FilterChipItem(id: null, label: 'Tümü'),
        for (final category in categories)
          FilterChipItem(id: category.id, label: category.name),
      ],
    );
  }
}

class _SubcategoryChips extends ConsumerWidget {
  const _SubcategoryChips({required this.filter});

  final MovementFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = categoriesById[filter.categoryId];
    if (category == null || !category.hasSubcategories) {
      return const SizedBox.shrink();
    }

    return FilterChipsBar(
      selectedId: filter.subcategoryId,
      onSelected: ref.read(movementFilterProvider.notifier).setSubcategory,
      items: [
        const FilterChipItem(id: null, label: 'Tümü'),
        for (final subcategory in category.subcategories)
          FilterChipItem(id: subcategory.id, label: subcategory.name),
      ],
    );
  }
}

class _MovementList extends ConsumerWidget {
  const _MovementList({required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryLookupProvider);
    final currency = ref.watch(selectedCurrencyProvider);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        children: [
          for (var i = 0; i < transactions.length; i++) ...[
            if (i > 0) const Divider(),
            _DismissibleTransaction(
              transaction: transactions[i],
              child: TransactionListItem(
                transaction: transactions[i],
                category: categories[transactions[i].categoryId],
                displayCurrency: currency,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DismissibleTransaction extends ConsumerWidget {
  const _DismissibleTransaction({
    required this.transaction,
    required this.child,
  });

  final Transaction transaction;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('transaction-${transaction.id}'),
      direction: DismissDirection.endToStart,
      background: const _DeleteBackground(),
      // The row disappears through the database stream, so the dismissal is
      // always reported as declined to keep the widget tree consistent.
      confirmDismiss: (_) async {
        final messenger = ScaffoldMessenger.of(context);
        final confirmed = await _confirmDelete(context);
        if (confirmed) await _delete(messenger, ref);
        return false;
      },
      child: child,
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İşlemi sil'),
        content: const Text('Bu işlemi silmek istediğine emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.negative),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _delete(ScaffoldMessengerState messenger, WidgetRef ref) async {
    try {
      await ref.read(transactionRepositoryProvider).deleteById(transaction.id);
    } on Object {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('İşlem silinemedi. Lütfen tekrar deneyin.'),
        ),
      );
    }
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.negativeSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: AppColors.negative,
      ),
    );
  }
}
