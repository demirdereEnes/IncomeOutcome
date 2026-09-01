import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Equal-width pill row used by the period and type filters.
class SegmentedPills<T> extends StatelessWidget {
  const SegmentedPills({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.height = 36,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          Expanded(
            child: _Pill(
              label: labelOf(values[i]),
              isSelected: values[i] == selected,
              height: height,
              onTap: () => onChanged(values[i]),
            ),
          ),
          if (i != values.length - 1) const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Horizontally scrollable chips for category / subcategory filtering.
class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  final List<FilterChipItem> items;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          return _Pill(
            label: item.label,
            isSelected: item.id == selectedId,
            height: 34,
            padded: true,
            onTap: () => onSelected(item.id),
          );
        },
      ),
    );
  }
}

class FilterChipItem {
  const FilterChipItem({required this.id, required this.label});

  /// Null represents the "Tümü" chip.
  final int? id;
  final String label;
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.isSelected,
    required this.height,
    required this.onTap,
    this.padded = false,
  });

  final String label;
  final bool isSelected;
  final double height;
  final bool padded;
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
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: height,
            alignment: Alignment.center,
            padding: padded
                ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
                : null,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
              borderRadius: radius,
            ),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 13,
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
