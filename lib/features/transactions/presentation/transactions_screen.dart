import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/transaction_list_item.dart';
import '../../categories/application/categories_providers.dart';
import '../../dashboard/application/dashboard_providers.dart';
import '../application/transactions_providers.dart';
import '../domain/transaction.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key, required this.onAddTransaction});

  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final categories = ref.watch(categoryLookupProvider);
    final currency = ref.watch(selectedCurrencyProvider);

    if (transactions.isEmpty) {
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
        AppCard(
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
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Bir işlemi silmek için sola kaydır.',
          textAlign: TextAlign.center,
          style: AppTypography.caption,
        ),
      ],
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
      child: const Icon(Icons.delete_outline_rounded, color: AppColors.negative),
    );
  }
}
