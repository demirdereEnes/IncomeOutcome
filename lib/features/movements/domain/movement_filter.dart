import '../../../shared/models/transaction_type.dart';
import '../../transactions/domain/transaction.dart';

enum MovementPeriod {
  oneMonth(label: '1 AY', months: 1),
  threeMonths(label: '3 AY', months: 3),
  sixMonths(label: '6 AY', months: 6),
  all(label: 'TÜMÜ', months: null);

  const MovementPeriod({required this.label, required this.months});

  final String label;
  final int? months;

  DateTime? startFrom(DateTime now) {
    final months = this.months;
    if (months == null) return null;
    return DateTime(now.year, now.month - months, now.day);
  }
}

/// Period -> type -> category -> subcategory. The chart, the totals and the
/// movement list all read this same object.
class MovementFilter {
  const MovementFilter({
    this.period = MovementPeriod.oneMonth,
    this.type,
    this.categoryId,
    this.subcategoryId,
  });

  final MovementPeriod period;

  /// Null means "TÜMÜ".
  final TransactionType? type;

  final int? categoryId;
  final int? subcategoryId;

  bool get hasCategory => categoryId != null;

  MovementFilter copyWith({
    MovementPeriod? period,
    Object? type = _unset,
    Object? categoryId = _unset,
    Object? subcategoryId = _unset,
  }) {
    return MovementFilter(
      period: period ?? this.period,
      type: identical(type, _unset) ? this.type : type as TransactionType?,
      categoryId: identical(categoryId, _unset)
          ? this.categoryId
          : categoryId as int?,
      subcategoryId: identical(subcategoryId, _unset)
          ? this.subcategoryId
          : subcategoryId as int?,
    );
  }

  List<Transaction> apply(List<Transaction> transactions, DateTime now) {
    final start = period.startFrom(now);

    return transactions.where((transaction) {
      if (start != null && transaction.transactionDate.isBefore(start)) {
        return false;
      }
      if (type != null && transaction.type != type) return false;
      if (categoryId != null && transaction.categoryId != categoryId) {
        return false;
      }
      if (subcategoryId != null && transaction.subcategoryId != subcategoryId) {
        return false;
      }
      return true;
    }).toList();
  }

  static const Object _unset = Object();
}
