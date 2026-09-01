import '../../../shared/models/currency.dart';
import '../../categories/domain/category_catalog.dart';
import '../../transactions/domain/transaction.dart';

/// One ring segment: a category, or a subcategory once the user drilled in.
class BreakdownSlice {
  const BreakdownSlice({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.amount,
    required this.share,
  });

  final int? id;
  final String label;
  final String iconKey;
  final double amount;

  /// 0..1
  final double share;

  double get percentage => share * 100;
}

class SpendingBreakdown {
  const SpendingBreakdown({
    required this.slices,
    required this.total,
    required this.isSubcategoryLevel,
  });

  final List<BreakdownSlice> slices;
  final double total;

  /// True when the ring shows subcategories of a drilled-into category.
  final bool isSubcategoryLevel;

  bool get isEmpty => slices.isEmpty || total <= 0;

  /// Groups by category, or by subcategory when [categoryId] is set.
  /// Values are converted with each entry's own historical snapshot.
  ///
  /// Debt movements are left out unless the user explicitly drilled into the
  /// debt category, so the ring keeps matching Total Expense instead of being
  /// swamped by money that was only moved around.
  factory SpendingBreakdown.from({
    required List<Transaction> transactions,
    required Currency currency,
    int? categoryId,
    bool includeDebtMovements = false,
  }) {
    final drilledIn = categoryId != null;
    final totals = <int?, double>{};
    var total = 0.0;

    for (final transaction in transactions) {
      if (!includeDebtMovements && transaction.isDebtMovement) continue;

      final amount = transaction.amountIn(currency) ?? 0;
      if (amount <= 0) continue;

      final key = drilledIn
          ? transaction.subcategoryId
          : transaction.categoryId;
      totals[key] = (totals[key] ?? 0) + amount;
      total += amount;
    }

    if (total <= 0) {
      return const SpendingBreakdown(
        slices: [],
        total: 0,
        isSubcategoryLevel: false,
      );
    }

    final slices = [
      for (final entry in totals.entries)
        BreakdownSlice(
          id: entry.key,
          label: _labelFor(entry.key, drilledIn: drilledIn),
          iconKey: _iconFor(entry.key, drilledIn: drilledIn),
          amount: entry.value,
          share: entry.value / total,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));

    return SpendingBreakdown(
      slices: slices,
      total: total,
      isSubcategoryLevel: drilledIn,
    );
  }

  static String _labelFor(int? id, {required bool drilledIn}) {
    if (id == null) return 'Belirtilmemiş';
    if (drilledIn) return subcategoriesById[id]?.name ?? 'Belirtilmemiş';
    return categoriesById[id]?.name ?? 'Diğer';
  }

  static String _iconFor(int? id, {required bool drilledIn}) {
    if (id == null) return 'other';
    if (drilledIn) {
      final parent = subcategoriesById[id]?.categoryId;
      return categoriesById[parent]?.iconKey ?? 'other';
    }
    return categoriesById[id]?.iconKey ?? 'other';
  }
}
