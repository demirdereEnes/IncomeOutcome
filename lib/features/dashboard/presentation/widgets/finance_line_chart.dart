import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/currency.dart';
import '../../domain/finance_chart_data.dart';

/// Cumulative income / expense / savings trend.
class FinanceLineChart extends StatelessWidget {
  const FinanceLineChart({
    super.key,
    required this.data,
    required this.currency,
  });

  final FinanceChartData data;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final maxX = math.max(data.maxX, 1.0);
    final yInterval = _niceInterval(data.maxY - data.minY);
    final maxY = (data.maxY / yInterval).ceilToDouble() * yInterval;
    final minY = data.minY < 0
        ? (data.minY / yInterval).floorToDouble() * yInterval
        : 0.0;
    final xInterval = math.max((maxX / 3).ceilToDouble(), 1.0);

    return Padding(
      // Room for the first/last bottom labels, which are centred on the edges.
      padding: const EdgeInsets.only(right: AppSpacing.xxl),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: minY,
          maxY: maxY == minY ? minY + yInterval : maxY,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppColors.chartGrid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: yInterval,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Text(
                    Formatters.compact(value),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    style: AppTypography.caption,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final date = data.firstDate.add(
                    Duration(days: value.round()),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      Formatters.axisDate(date),
                      maxLines: 1,
                      style: AppTypography.caption,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(AppRadius.sm),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              maxContentWidth: 220,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (_) => AppColors.textPrimary,
              getTooltipItems: _tooltipItems,
            ),
            getTouchedSpotIndicator: (barData, indexes) => [
              for (final _ in indexes)
                TouchedSpotIndicatorData(
                  const FlLine(color: AppColors.textTertiary, strokeWidth: 1),
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                          radius: 4,
                          color: bar.color ?? AppColors.primary,
                          strokeWidth: 2,
                          strokeColor: AppColors.surface,
                        ),
                  ),
                ),
            ],
          ),
          lineBarsData: [
            _series((point) => point.income, AppColors.chartIncome),
            _series((point) => point.expense, AppColors.chartExpense),
            _series((point) => point.saving, AppColors.chartSaving),
          ],
        ),
      ),
    );
  }

  /// Rounds the axis step to 1/2/2.5/5 x 10^n so labels read as whole numbers.
  static double _niceInterval(double range) {
    if (range <= 0 || !range.isFinite) return 1;
    final rough = range / 4;
    final exponent = (math.log(rough) / math.ln10).floor();
    final magnitude = math.pow(10, exponent).toDouble();
    final normalized = rough / magnitude;
    final step = normalized <= 1
        ? 1.0
        : normalized <= 2
        ? 2.0
        : normalized <= 2.5
        ? 2.5
        : normalized <= 5
        ? 5.0
        : 10.0;
    return step * magnitude;
  }

  LineChartBarData _series(double Function(ChartPoint) selector, Color color) {
    return LineChartBarData(
      spots: [
        for (final point in data.points)
          FlSpot(data.xOf(point), selector(point)),
      ],
      isCurved: true,
      curveSmoothness: 0.22,
      preventCurveOverShooting: true,
      color: color,
      barWidth: 2.4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: data.points.length <= 16,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 2.6,
          color: color,
          strokeWidth: 0,
          strokeColor: Colors.transparent,
        ),
      ),
    );
  }

  List<LineTooltipItem?> _tooltipItems(List<LineBarSpot> spots) {
    const labels = ['Gelir', 'Gider', 'Birikim'];
    const headerStyle = TextStyle(
      color: Colors.white70,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    return [
      for (var i = 0; i < spots.length; i++)
        LineTooltipItem(
          '${labels[spots[i].barIndex]}  ${Formatters.money(spots[i].y, currency)}',
          TextStyle(
            color: spots[i].bar.color ?? Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
          children: i == 0
              ? [
                  TextSpan(
                    text:
                        '\n${Formatters.fullDate(data.firstDate.add(Duration(days: spots[i].x.round())))}',
                    style: headerStyle,
                  ),
                ]
              : null,
        ),
    ];
  }
}
