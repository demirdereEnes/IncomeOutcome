import '../../../shared/models/currency.dart';
import '../../../shared/models/transaction_type.dart';
import '../../rates/domain/currency_conversion_service.dart';
import '../../rates/domain/exchange_rates.dart';

/// A single income, expense or saving entry.
///
/// The amount stays in the currency the user actually entered, as minor units
/// (scale 100) so the stored value remains exact. [rates] is the immutable
/// snapshot taken at save time and must never be recalculated later.
class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.currency,
    required this.amountMinor,
    required this.categoryId,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.rates,
    this.rateSnapshotAt,
  });

  final int id;
  final TransactionType type;
  final Currency currency;

  /// Amount in [currency], scaled by 100 (kuruş, cents, centigrams of gold).
  final int amountMinor;

  final int categoryId;
  final DateTime transactionDate;
  final String? description;

  /// Rates frozen at save time. Null only for TRY entries recorded while no
  /// quote was available at all.
  final ExchangeRates? rates;

  /// When the attached rates were quoted.
  final DateTime? rateSnapshotAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  double get amount => amountMinor / 100;

  /// Historical TRY value of this entry. Null when no snapshot was stored.
  double? get tryAmountSnapshot =>
      CurrencyConversionService.historicalTryAmount(this);

  double? amountIn(Currency target) =>
      CurrencyConversionService.historicalAmount(this, target);

  Transaction copyWith({
    TransactionType? type,
    Currency? currency,
    int? amountMinor,
    int? categoryId,
    DateTime? transactionDate,
    Object? description = _unset,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      amountMinor: amountMinor ?? this.amountMinor,
      categoryId: categoryId ?? this.categoryId,
      transactionDate: transactionDate ?? this.transactionDate,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      rates: rates,
      rateSnapshotAt: rateSnapshotAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const Object _unset = Object();
}

/// Payload for creating an entry; the repository assigns id and timestamps.
class NewTransaction {
  const NewTransaction({
    required this.type,
    required this.currency,
    required this.amountMinor,
    required this.categoryId,
    required this.transactionDate,
    this.description,
    this.rates,
  });

  final TransactionType type;
  final Currency currency;
  final int amountMinor;
  final int categoryId;
  final DateTime transactionDate;
  final String? description;
  final ExchangeRates? rates;
}
