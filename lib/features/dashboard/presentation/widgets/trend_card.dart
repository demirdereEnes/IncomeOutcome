import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/currency.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/finance_chart_data.dart';
import 'finance_line_chart.dart';
import 'finance_summary_card.dart';

/// Chart card: shows the real trend once there is enough history, otherwise a
/// progress-driven onboarding state.
class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.data,
    required this.currency,
    required this.transactionCount,
  });

  final FinanceChartData data;
  final Currency currency;
  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    final hasEnoughData =
        transactionCount >= FinanceChartData.minimumTransactions &&
        data.points.length > 1;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Finansal Trend',
                  style: AppTypography.sectionTitle,
                ),
              ),
              if (hasEnoughData) const ChartLegend(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasEnoughData)
            SizedBox(
              height: 200,
              child: FinanceLineChart(data: data, currency: currency),
            )
          else
            _ChartProgressState(transactionCount: transactionCount),
        ],
      ),
    );
  }
}

class _ChartProgressState extends StatelessWidget {
  const _ChartProgressState({required this.transactionCount});

  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    const target = FinanceChartData.minimumTransactions;
    final progress = (transactionCount / target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Finansal trendin oluşuyor',
            style: AppTypography.body,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Daha anlamlı bir grafik için işlem eklemeye devam et.',
            style: AppTypography.label.copyWith(height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('$transactionCount / $target işlem', style: AppTypography.caption),
        ],
      ),
    );
  }
}
