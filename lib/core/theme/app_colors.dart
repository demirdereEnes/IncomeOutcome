import 'package:flutter/material.dart';

import '../../shared/models/transaction_type.dart';

/// Central colour palette. Never hard-code colours in widgets.
abstract final class AppColors {
  // Brand - soft turquoise / teal
  static const Color primary = Color(0xFF14A79D);
  static const Color primaryDark = Color(0xFF0D8179);
  static const Color primarySoft = Color(0xFFE1F4F2);

  // Semantic
  static const Color positive = Color(0xFF17A05C);
  static const Color positiveSoft = Color(0xFFE6F6EE);
  static const Color negative = Color(0xFFDF4C4C);
  static const Color negativeSoft = Color(0xFFFCECEC);

  /// Savings own a turquoise-blue of their own so they never read as income.
  static const Color saving = Color(0xFF2E9BC9);
  static const Color savingSoft = Color(0xFFE4F2F9);

  static const Color warning = Color(0xFFE58A3C);
  static const Color warningSoft = Color(0xFFFDF0E4);

  // Surfaces
  static const Color background = Color(0xFFF4F7F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEEF2F4);
  static const Color border = Color(0xFFE2E9ED);

  // Text
  static const Color textPrimary = Color(0xFF16212E);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF95A3B4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Chart series
  static const Color chartIncome = positive;
  static const Color chartExpense = negative;
  static const Color chartSaving = saving;
  static const Color chartGrid = Color(0xFFEBF0F3);

  static Color accentFor(TransactionType type) => switch (type) {
    TransactionType.income => positive,
    TransactionType.expense => negative,
    TransactionType.saving => saving,
  };

  static Color softFor(TransactionType type) => switch (type) {
    TransactionType.income => positiveSoft,
    TransactionType.expense => negativeSoft,
    TransactionType.saving => savingSoft,
  };
}
