import '../../../shared/models/currency.dart';
import '../../../shared/models/debt_operation.dart';
import '../../categories/domain/category_catalog.dart';
import '../../rates/domain/currency_conversion_service.dart';
import '../../rates/domain/exchange_rates.dart';
import '../../transactions/domain/transaction.dart';

/// A debt balance, derived from the debt movements the user recorded.
///
/// Balances are never stored: deriving them from the transactions keeps them
/// correct after an edit or a delete, with no chance of drift.
class Debt {
  const Debt({
    required this.subcategoryId,
    required this.name,
    required this.currency,
    required this.addedMinor,
    required this.paidMinor,
    required this.createdAt,
    required this.updatedAt,
  });

  final int subcategoryId;
  final String name;
  final Currency currency;
  final int addedMinor;
  final int paidMinor;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get id => '$subcategoryId-${currency.code}';

  /// Everything ever borrowed, in the debt's own currency.
  double get originalAmount => addedMinor / 100;

  double get paidAmount => paidMinor / 100;

  int get remainingMinor => addedMinor - paidMinor;

  double get remainingAmount => remainingMinor / 100;

  bool get isActive => remainingMinor > 0;

  /// Today's worth of the outstanding balance. Uses the *current* rate, never
  /// a historical snapshot - the debt itself stays denominated in [currency].
  double? currentValueIn(Currency target, ExchangeRates? rates) {
    if (currency == target) return remainingAmount;
    if (rates == null) return null;
    return CurrencyConversionService.convert(
      amount: remainingAmount,
      from: currency,
      to: target,
      rates: rates,
    );
  }
}

abstract final class DebtService {
  /// Groups debt movements by subcategory and currency, e.g. "Altın Borcu"
  /// in XAU is one balance regardless of how many entries built it up.
  static List<Debt> buildAll(List<Transaction> transactions) {
    final buckets = <String, _DebtBucket>{};

    for (final transaction in transactions) {
      final operation = transaction.debtOperation;
      final subcategoryId = transaction.subcategoryId;
      if (operation == null || subcategoryId == null) continue;

      final key = '$subcategoryId-${transaction.currency.code}';
      final bucket = buckets.putIfAbsent(
        key,
        () => _DebtBucket(
          subcategoryId: subcategoryId,
          currency: transaction.currency,
          first: transaction.transactionDate,
        ),
      );
      bucket.apply(operation, transaction);
    }

    final debts = [
      for (final bucket in buckets.values)
        Debt(
          subcategoryId: bucket.subcategoryId,
          name: _nameFor(bucket.subcategoryId),
          currency: bucket.currency,
          addedMinor: bucket.addedMinor,
          paidMinor: bucket.paidMinor,
          createdAt: bucket.first,
          updatedAt: bucket.last,
        ),
    ];

    debts.sort((a, b) => b.remainingMinor.compareTo(a.remainingMinor));
    return debts;
  }

  /// Outstanding debt expressed in [currency], using current market rates.
  static double totalIn({
    required List<Debt> debts,
    required Currency currency,
    required ExchangeRates? rates,
  }) {
    var total = 0.0;
    for (final debt in debts) {
      if (!debt.isActive) continue;
      total += debt.currentValueIn(currency, rates) ?? 0;
    }
    return total;
  }

  static String _nameFor(int subcategoryId) =>
      subcategoriesById[subcategoryId]?.name ?? 'Borç';
}

class _DebtBucket {
  _DebtBucket({
    required this.subcategoryId,
    required this.currency,
    required DateTime first,
  }) : first = first,
       last = first;

  final int subcategoryId;
  final Currency currency;
  DateTime first;
  DateTime last;
  int addedMinor = 0;
  int paidMinor = 0;

  void apply(DebtOperation operation, Transaction transaction) {
    switch (operation) {
      case DebtOperation.add:
        addedMinor += transaction.amountMinor;
      case DebtOperation.pay:
        paidMinor += transaction.amountMinor;
    }
    if (transaction.transactionDate.isBefore(first)) {
      first = transaction.transactionDate;
    }
    if (transaction.transactionDate.isAfter(last)) {
      last = transaction.transactionDate;
    }
  }
}
