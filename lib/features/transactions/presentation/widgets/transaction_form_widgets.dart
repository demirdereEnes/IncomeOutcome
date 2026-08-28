import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/currency.dart';
import '../../../../shared/models/transaction_type.dart';

/// Label + field pairing used by every row of the transaction form.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

/// Income / expense / saving switch. Selection colour matches the semantic
/// meaning of the type.
class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final type in TransactionType.values)
            Expanded(
              child: _TypeOption(
                type: type,
                isSelected: type == selected,
                onTap: () => onChanged(type),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final TransactionType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentFor(type);
    final radius = BorderRadius.circular(AppRadius.sm);

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
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? accent : Colors.transparent,
              borderRadius: radius,
            ),
            child: Text(
              type.label,
              style: AppTypography.body.copyWith(
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

/// Keeps the raw text a plain Turkish decimal (`12345,67`) so parsing stays
/// trivial and the caret never jumps while typing.
class AmountInputFormatter extends TextInputFormatter {
  static final RegExp _pattern = RegExp(r'^\d{0,12}(,\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    return _pattern.hasMatch(newValue.text) ? newValue : oldValue;
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.controller,
    required this.currency,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final Currency currency;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final affixStyle = AppTypography.displayAmount.copyWith(
      fontSize: 22,
      color: AppColors.textSecondary,
    );

    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [AmountInputFormatter()],
      style: AppTypography.displayAmount.copyWith(fontSize: 28),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: AppTypography.displayAmount.copyWith(
          fontSize: 28,
          color: AppColors.textTertiary,
        ),
        prefixIcon: currency.symbolIsPrefix
            ? Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.sm,
                ),
                child: Text(currency.symbol, style: affixStyle),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: currency.symbolIsPrefix
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: Text(currency.symbol.trim(), style: affixStyle),
              ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Lütfen bir tutar girin.' : null,
    );
  }
}

/// Read-only field that opens a picker (category, date).
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.text,
    required this.trailingIcon,
    required this.onTap,
    this.leadingIcon,
    this.isPlaceholder = false,
  });

  final String text;
  final IconData trailingIcon;
  final IconData? leadingIcon;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);

    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.body.copyWith(
                    color: isPlaceholder
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(trailingIcon, size: 20, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
