import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/currency.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_widgets.dart';
import '../../domain/spending_breakdown.dart';

/// Calm, restrained palette; slices cycle through it in descending order.
const List<Color> _slicePalette = [
  AppColors.primary,
  AppColors.saving,
  AppColors.warning,
  AppColors.positive,
  AppColors.negative,
  Color(0xFF7FA8B8),
  Color(0xFFB99530),
  Color(0xFF8C8FA3),
];

/// Distribution ring for the currently filtered movements. Tapping a slice
/// drills into that category.
class SpendingDonutCard extends StatelessWidget {
  const SpendingDonutCard({
    super.key,
    required this.breakdown,
    required this.currency,
    required this.title,
    required this.onSliceTap,
  });

  final SpendingBreakdown breakdown;
  final Currency currency;
  final String title;

  /// Null when the ring already shows subcategories.
  final ValueChanged<int?>? onSliceTap;

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const AppCard(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: EmptyState(
          icon: Icons.donut_large_rounded,
          title: 'Bu filtre için henüz işlem yok',
          message:
              'İşlem ekleyerek finansal dağılımını görmeye başlayabilirsin.',
        ),
      );
    }

    final slices = breakdown.slices;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: AppTypography.sectionTitle)),
              Text(
                Formatters.money(breakdown.total, currency),
                style: AppTypography.amountMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 168,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 46,
                startDegreeOffset: -90,
                pieTouchData: PieTouchData(
                  enabled: onSliceTap != null,
                  touchCallback: (event, response) {
                    if (onSliceTap == null || !event.isInterestedForInteractions) {
                      return;
                    }
                    final index = response?.touchedSection?.touchedSectionIndex;
                    if (index == null || index < 0 || index >= slices.length) {
                      return;
                    }
                    onSliceTap!(slices[index].id);
                  },
                ),
                sections: [
                  for (var i = 0; i < slices.length; i++)
                    PieChartSectionData(
                      value: slices[i].amount,
                      color: _slicePalette[i % _slicePalette.length],
                      radius: 26,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < slices.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            _LegendRow(
              color: _slicePalette[i % _slicePalette.length],
              slice: slices[i],
              currency: currency,
              onTap: onSliceTap == null
                  ? null
                  : () => onSliceTap!(slices[i].id),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.slice,
    required this.currency,
    required this.onTap,
  });

  final Color color;
  final BreakdownSlice slice;
  final Currency currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              slice.label,
              style: AppTypography.label.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            Formatters.money(slice.amount, currency),
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 44,
            child: Text(
              '%${slice.percentage.toStringAsFixed(slice.percentage >= 10 ? 0 : 1)}',
              textAlign: TextAlign.right,
              style: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }
}
