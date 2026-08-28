import '../../../shared/models/currency.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/exchange_rates.dart';

/// All currency maths lives here; widgets never convert on their own.
///
/// TRY is the pivot: `amount x rate(from)` gives TRY, `/ rate(to)` gives the
/// target currency.
abstract final class CurrencyConversionService {
  static double convert({
    required double amount,
    required Currency from,
    required Currency to,
    required ExchangeRates rates,
  }) {
    if (from == to) return amount;
    return amount * rates.rateFor(from) / rates.rateFor(to);
  }

  /// Historical value of [transaction] in [target], using the rates frozen at
  /// save time. Returns `null` when the entry was stored without a snapshot
  /// and the conversion would need one.
  static double? historicalAmount(Transaction transaction, Currency target) {
    if (transaction.currency == target) return transaction.amount;

    final rates = transaction.rates;
    if (rates == null) return null;

    return convert(
      amount: transaction.amount,
      from: transaction.currency,
      to: target,
      rates: rates,
    );
  }

  /// TRY equivalent shown next to the original amount on movement rows.
  static double? historicalTryAmount(Transaction transaction) =>
      historicalAmount(transaction, Currency.tryLira);
}
