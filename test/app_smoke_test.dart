import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/app/app.dart';
import 'package:income_outcome/features/rates/application/rates_providers.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_repository.dart';
import 'package:income_outcome/features/rates/domain/exchange_rates.dart';
import 'package:income_outcome/features/transactions/application/transactions_providers.dart';
import 'package:income_outcome/features/transactions/domain/transaction.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final _rates = ExchangeRates(
  usdTry: 41.2536,
  eurTry: 48.1120,
  xauTry: 5842.30,
  fetchedAt: DateTime(2026, 8, 29, 9, 30),
  source: 'test',
);

Transaction _tx({
  required int id,
  required TransactionType type,
  required Currency currency,
  required double amount,
}) {
  final when = DateTime(2026, 8, 29 - id);
  return Transaction(
    id: id,
    type: type,
    currency: currency,
    amountMinor: (amount * 100).round(),
    categoryId: switch (type) {
      TransactionType.income => 1,
      TransactionType.expense => 7,
      TransactionType.saving => 16,
    },
    transactionDate: when,
    rates: _rates,
    rateSnapshotAt: _rates.fetchedAt,
    createdAt: when,
    updatedAt: when,
  );
}

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'tr_TR';
    await initializeDateFormatting('tr_TR');
  });

  Future<void> pumpApp(WidgetTester tester, List<Transaction> transactions) {
    // Tall surface so the whole dashboard, including the movement list,
    // is laid out and reachable by the finders.
    tester.view.physicalSize = const Size(500, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async {}),
          transactionsProvider.overrideWith((ref) => Stream.value(transactions)),
          currentRatesProvider.overrideWith(
            (ref) async => RatesLoadResult(rates: _rates),
          ),
        ],
        child: const IncomeOutcomeApp(),
      ),
    );
  }

  testWidgets('dashboard renders totals, movements and the currency filter', (
    tester,
  ) async {
    await pumpApp(tester, [
      _tx(
        id: 1,
        type: TransactionType.income,
        currency: Currency.tryLira,
        amount: 125000,
      ),
      _tx(
        id: 2,
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 60,
      ),
      _tx(
        id: 3,
        type: TransactionType.saving,
        currency: Currency.xau,
        amount: 5,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('TL'), findsOneWidget);
    expect(find.text('XAU'), findsOneWidget);
    expect(find.text('Toplam Gelir'), findsOneWidget);
    expect(find.text('Bu Ay Gider'), findsOneWidget);

    // Original currency headline plus the TRY equivalent from the snapshot.
    expect(find.text(r'- $60,00'), findsOneWidget);
    expect(find.text('≈ ₺2.475,22'), findsOneWidget);
    expect(find.text('+ 5,00 gr'), findsOneWidget);
    expect(find.text('≈ ₺29.211,50'), findsOneWidget);

    // A TRY entry shows no redundant conversion line.
    expect(find.text('+ ₺125.000,00'), findsOneWidget);
  });

  testWidgets('empty database shows the onboarding state', (tester) async {
    await pumpApp(tester, const []);
    await tester.pumpAndSettle();

    expect(find.text('Finansal yolculuğunu başlat'), findsOneWidget);
    expect(find.text('İlk İşlemini Ekle'), findsOneWidget);
  });

  testWidgets('the new transaction form offers all types and currencies', (
    tester,
  ) async {
    await pumpApp(tester, const []);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Yeni İşlem'), findsOneWidget);
    expect(find.text('Gelir'), findsOneWidget);
    expect(find.text('Gider'), findsOneWidget);
    expect(find.text('Birikim'), findsOneWidget);
    expect(find.text('TRY'), findsOneWidget);
    // USD / EUR / XAU also appear in the rate snapshot card below the form.
    expect(find.text('USD'), findsWidgets);
    expect(find.text('EUR'), findsWidgets);
    expect(find.text('XAU'), findsWidgets);
    expect(find.text('Kaydet'), findsOneWidget);
  });
}
