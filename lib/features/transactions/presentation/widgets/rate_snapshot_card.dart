import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../rates/domain/exchange_rates.dart';

/// Current rates plus the timestamp they actually belong to.
///
/// "Son güncelleme" is the moment the app last received a validated response;
/// opening the app, the screen or rebuilding this widget never changes it.
class RateSnapshotCard extends StatelessWidget {
  const RateSnapshotCard({
    super.key,
    required this.rates,
    required this.onRefresh,
    this.isLoading = false,
    this.isRefreshing = false,
    this.refreshFailed = false,
  });

  final ExchangeRates? rates;
  final VoidCallback onRefresh;
  final bool isLoading;
  final bool isRefreshing;
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
            'Güncel Kurlar',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  _timestampLabel(rates),
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _RefreshButton(
                isBusy: isRefreshing,
                onPressed: isRefreshing ? null : onRefresh,
              ),
            ],
          ),
          if (refreshFailed) ...[
            const SizedBox(height: AppSpacing.md),
            _Notice(
              message: rates == null
                  ? 'Kur alınamadı. Şimdilik sadece TL işlem kaydedebilirsin.'
                  : 'Kur güncellenemedi. Son kayıtlı kur kullanılıyor.',
            ),
          ],
        ],
      ),
    );
  }

  String _timestampLabel(ExchangeRates? rates) {
    if (isLoading && rates == null) return 'Kurlar alınıyor...';
    if (rates == null) return 'Kur bilgisi bulunamadı';
    return 'Son güncelleme: ${Formatters.time(rates.fetchedAt)}';
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.isBusy, required this.onPressed});

  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : const Icon(Icons.refresh_rounded, size: 18),
      label: Text(isBusy ? 'Güncelleniyor...' : 'Güncelle'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
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
  const _Notice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.warning),
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
