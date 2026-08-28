import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../models/currency.dart';

/// Pill-shaped currency switcher: TL | USD | EUR | XAU.
class CurrencySegmentedControl extends StatelessWidget {
  const CurrencySegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
    this.useIsoCode = false,
    this.height = 40,
  });

  final Currency selected;
  final ValueChanged<Currency> onChanged;

  /// Shows `TRY` instead of `TL`, used by the entry form.
  final bool useIsoCode;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final currency in Currency.values) ...[
          Expanded(
            child: _CurrencyPill(
              label: useIsoCode ? currency.code : currency.label,
              isSelected: currency == selected,
              height: height,
              onTap: () => onChanged(currency),
            ),
          ),
          if (currency != Currency.values.last)
            const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.label,
    required this.isSelected,
    required this.height,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
              borderRadius: radius,
            ),
            child: Text(
              label,
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
