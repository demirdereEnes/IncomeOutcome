import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/currency.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../shared/widgets/currency_segmented_control.dart';
import '../../../shared/widgets/transaction_list_item.dart';
import '../../categories/application/categories_providers.dart';
import '../../finance/application/financial_providers.dart';
import '../../rates/application/rates_providers.dart';
import '../../transactions/application/transactions_providers.dart';
import '../application/dashboard_providers.dart';
import 'widgets/finance_summary_card.dart';
import 'widgets/net_worth_card.dart';
import 'widgets/trend_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.onSeeAllTransactions,
    required this.onAddTransaction,
  });

  final VoidCallback onSeeAllTransactions;
  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return transactions.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Padding(
        padding: EdgeInsets.all(AppSpacing.page),
        child: Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Veriler yüklenemedi',
            message: 'Kayıtlı işlemler okunamadı. Uygulamayı yeniden başlat.',
          ),
        ),
      ),
      data: (_) => _DashboardContent(
        onSeeAllTransactions: onSeeAllTransactions,
        onAddTransaction: onAddTransaction,
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({
    required this.onSeeAllTransactions,
    required this.onAddTransaction,
  });

  final VoidCallback onSeeAllTransactions;
  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(selectedCurrencyProvider);
    final summary = ref.watch(financialSummaryProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxxl * 3,
      ),
      children: [
        CurrencySegmentedControl(
          selected: currency,
          onChanged: ref.read(selectedCurrencyProvider.notifier).select,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (summary.isEmpty)
          _DashboardEmptyState(onAddTransaction: onAddTransaction)
        else ...[
          NetWorthCard(summary: summary),
          const SizedBox(height: AppSpacing.md),
          SummaryCardRow(
            left: FinanceSummaryCard(
              icon: Icons.south_west_rounded,
              iconColor: AppColors.positive,
              iconBackground: AppColors.positiveSoft,
              label: 'Toplam Gelir',
              value: Formatters.money(summary.totalIncome, currency),
            ),
            right: FinanceSummaryCard(
              icon: Icons.north_east_rounded,
              iconColor: AppColors.negative,
              iconBackground: AppColors.negativeSoft,
              label: 'Toplam Gider',
              value: Formatters.money(summary.totalExpense, currency),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SummaryCardRow(
            left: FinanceSummaryCard(
              icon: Icons.savings_outlined,
              iconColor: summary.netSavings < 0
                  ? AppColors.negative
                  : AppColors.positive,
              iconBackground: summary.netSavings < 0
                  ? AppColors.negativeSoft
                  : AppColors.positiveSoft,
              label: 'Net Birikim',
              value: Formatters.money(summary.netSavings, currency),
              caption: 'Gelir - Gider',
            ),
            right: FinanceSummaryCard(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.saving,
              iconBackground: AppColors.savingSoft,
              label: 'Toplam Varlık',
              value: Formatters.money(summary.totalAssets, currency),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SummaryCardRow(
            left: FinanceSummaryCard(
              icon: Icons.workspace_premium_outlined,
              iconColor: AppColors.saving,
              iconBackground: AppColors.savingSoft,
              label: 'Manuel Birikim',
              value: Formatters.money(summary.manualAssets, currency),
            ),
            right: FinanceSummaryCard(
              icon: Icons.calendar_today_outlined,
              iconColor: AppColors.warning,
              iconBackground: AppColors.warningSoft,
              label: 'Bu Ay Gider',
              value: Formatters.money(summary.currentMonthExpense, currency),
            ),
          ),
          if (summary.totalDebt > 0) ...[
            const SizedBox(height: AppSpacing.md),
            const _DebtSummaryCard(),
          ],
          const SizedBox(height: AppSpacing.xxl),
          TrendCard(
            data: ref.watch(chartDataProvider),
            currency: currency,
            transactionCount: summary.transactionCount,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Hareketler',
            actionLabel: 'Tümü',
            onAction: onSeeAllTransactions,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _RecentTransactions(),
        ],
      ],
    );
  }
}

class _DebtSummaryCard extends ConsumerWidget {
  const _DebtSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(activeDebtsProvider);
    final currency = ref.watch(selectedCurrencyProvider);
    if (debts.isEmpty) return const SizedBox.shrink();

    // Debt is valued with today's rate, never a historical snapshot.
    final rates = ref.watch(currentExchangeRatesProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Borçlar'),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < debts.length; i++) ...[
            if (i > 0) const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  const SoftIcon(
                    icon: Icons.credit_card_outlined,
                    color: AppColors.negative,
                    background: AppColors.negativeSoft,
                    size: 34,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      debts[i].name,
                      style: AppTypography.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _DebtAmount(
                    original: Formatters.money(
                      debts[i].remainingAmount,
                      debts[i].currency,
                    ),
                    converted: debts[i].currency == currency
                        ? null
                        : debts[i].currentValueIn(currency, rates),
                    currency: currency,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DebtAmount extends StatelessWidget {
  const _DebtAmount({
    required this.original,
    required this.converted,
    required this.currency,
  });

  final String original;
  final double? converted;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final converted = this.converted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          original,
          style: AppTypography.amountMedium.copyWith(
            color: AppColors.negative,
          ),
        ),
        if (converted != null) ...[
          const SizedBox(height: 2),
          Text(
            Formatters.approx(converted, currency),
            style: AppTypography.caption,
          ),
        ],
      ],
    );
  }
}

class _RecentTransactions extends ConsumerWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(recentTransactionsProvider);
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
            TransactionListItem(
              transaction: transactions[i],
              category: categories[transactions[i].categoryId],
              displayCurrency: currency,
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardEmptyState extends StatelessWidget {
  const _DashboardEmptyState({required this.onAddTransaction});

  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: EmptyState(
        icon: Icons.auto_graph_rounded,
        title: 'Finansal yolculuğunu başlat',
        message:
            'İlk gelir, gider veya birikimini ekleyerek finansal durumunu takip etmeye başla.',
        action: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onAddTransaction,
            child: const Text('İlk İşlemini Ekle'),
          ),
        ),
      ),
    );
  }
}
