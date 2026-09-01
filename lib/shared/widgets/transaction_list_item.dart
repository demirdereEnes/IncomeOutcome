import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../features/categories/domain/category.dart';
import '../../features/categories/domain/category_catalog.dart';
import '../../features/transactions/domain/transaction.dart';
import '../models/currency.dart';
import 'app_widgets.dart';

/// A single row in the movements list.
///
/// The headline figure is always the amount in the currency the entry was
/// created with; the muted line underneath converts it to the currency
/// currently selected on the dashboard, using the entry's own snapshot.
class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.category,
    required this.displayCurrency,
  });

  final Transaction transaction;
  final Category? category;
  final Currency displayCurrency;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentFor(transaction.type);
    final converted = transaction.currency == displayCurrency
        ? null
        : transaction.amountIn(displayCurrency);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          SoftIcon(
            icon: categoryIcon(category?.iconKey ?? 'other'),
            color: accent,
            background: AppColors.softFor(transaction.type),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category?.name ?? 'Diğer',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(),
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ScaledText(
                  text: Formatters.signedMoney(
                    transaction.amount,
                    transaction.currency,
                    negative: transaction.type.isNegative,
                  ),
                  style: AppTypography.amountMedium.copyWith(color: accent),
                ),
                if (converted != null) ...[
                  const SizedBox(height: 2),
                  _ScaledText(
                    text: Formatters.approx(converted, displayCurrency),
                    style: AppTypography.caption,
                  ),
                ],
                const SizedBox(height: 2),
                Text(transaction.type.label, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    final date = Formatters.fullDate(transaction.transactionDate);
    final description = transaction.description;
    if (description == null || description.isEmpty) return date;
    return '$date · $description';
  }
}

class _ScaledText extends StatelessWidget {
  const _ScaledText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Text(text, maxLines: 1, style: style),
    );
  }
}
