import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../rates/domain/exchange_rates.dart';

/// Shows the rates that will be frozen onto the new entry, so it is obvious
/// that its historical value never changes afterwards.
class RateSnapshotCard extends StatelessWidget {
  const RateSnapshotCard({
    super.key,
    required this.rates,
    this.isLoading = false,
    this.refreshFailed = false,
  });

  final ExchangeRates? rates;
  final bool isLoading;
  final bool refreshFailed;

  @override
  Widget build(BuildContext context) {
    final rates = this.rates;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kayıt Anındaki Kurlar',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(_subtitle(rates), style: AppTypography.caption),
          if (rates != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _RateTile(
                    label: 'USD',
                    value: Formatters.rate(rates.usdTry),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _RateTile(
                    label: 'EUR',
                    value: Formatters.rate(rates.eurTry),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _RateTile(
                    label: 'XAU (1 gr)',
                    value: Formatters.rate(rates.xauTry, decimals: 2),
                  ),
                ),
              ],
            ),
          ],
          if (refreshFailed) ...[
            const SizedBox(height: AppSpacing.md),
            _Notice(
              icon: Icons.cloud_off_rounded,
              message: rates == null
                  ? 'Kurlar alınamadı. Sadece TL işlem kaydedebilirsin.'
                  : 'Kurlar güncellenemedi. Son kullanılan kurlar kullanılıyor.',
            ),
          ],
        ],
      ),
    );
  }

  String _subtitle(ExchangeRates? rates) {
    if (isLoading) return 'Kurlar alınıyor...';
    if (rates == null) return 'Kur bilgisi bulunamadı';
    return '${Formatters.fullDate(rates.fetchedAt)} · ${Formatters.time(rates.fetchedAt)}';
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.warning),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: AppTypography.caption.copyWith(
              color: AppColors.warning,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
