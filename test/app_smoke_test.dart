import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_outcome/app/app.dart';
import 'package:income_outcome/features/rates/application/rates_providers.dart';
import 'package:income_outcome/features/rates/data/exchange_rate_repository.dart';
import 'package:income_outcome/features/transactions/application/transactions_providers.dart';
import 'package:income_outcome/features/transactions/domain/transaction.dart';
import 'package:income_outcome/shared/models/currency.dart';
import 'package:income_outcome/shared/models/debt_operation.dart';
import 'package:income_outcome/shared/models/transaction_type.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'support/test_data.dart';

class _FakeRatesNotifier extends CurrentRatesNotifier {
  @override
  Future<RatesLoadResult> build() async => RatesLoadResult(rates: testRates);
}

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'tr_TR';
    await initializeDateFormatting('tr_TR');
  });

  setUp(resetTestIds);

  Future<void> pumpApp(WidgetTester tester, List<Transaction> transactions) {
    // Tall surface so the whole dashboard is laid out for the finders.
    tester.view.physicalSize = const Size(500, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async {}),
          transactionsProvider.overrideWith((ref) => Stream.value(transactions)),
          currentRatesProvider.overrideWith(_FakeRatesNotifier.new),
        ],
        child: const IncomeOutcomeApp(),
      ),
    );
  }

  testWidgets('dashboard leads with net worth and keeps the summary cards', (
    tester,
  ) async {
    await pumpApp(tester, [
      tx(type: TransactionType.income, amount: 500000, categoryId: 100),
      tx(type: TransactionType.expense, amount: 350000, categoryId: 113),
      tx(type: TransactionType.saving, amount: 100000, categoryId: 133),
      tx(
        type: TransactionType.expense,
        amount: 60000,
        categoryId: 118,
        subcategoryId: 11804,
        debtOperation: DebtOperation.add,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('NET VARLIK'), findsOneWidget);
    expect(find.text('₺190.000,00'), findsOneWidget);
    expect(find.text('Toplam Gelir'), findsOneWidget);
    expect(find.text('Toplam Gider'), findsOneWidget);
    expect(find.text('Net Birikim'), findsOneWidget);
    expect(find.text('Toplam Varlık'), findsOneWidget);

    // The debt movement must not inflate Total Expense.
    expect(find.text('₺350.000,00'), findsOneWidget);
    // Varlık / Toplam Varlık both render the same figure.
    expect(find.text('₺250.000,00'), findsNWidgets(2));
  });

  testWidgets('negative net savings is shown, not clamped', (tester) async {
    await pumpApp(tester, [
      tx(type: TransactionType.income, amount: 100000, categoryId: 100),
      tx(type: TransactionType.expense, amount: 125000, categoryId: 113),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('-₺25.000,00'), findsWidgets);
  });

  testWidgets('movement rows keep the original currency and historical TRY', (
    tester,
  ) async {
    await pumpApp(tester, [
      tx(type: TransactionType.income, amount: 125000, categoryId: 100),
      tx(
        type: TransactionType.expense,
        currency: Currency.usd,
        amount: 60,
        categoryId: 112,
        subcategoryId: 11200,
      ),
      tx(
        type: TransactionType.saving,
        currency: Currency.xau,
        amount: 5,
        categoryId: 130,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.text(r'- $60,00'), findsOneWidget);
    expect(find.text('≈ ₺2.475,22'), findsOneWidget);
    expect(find.text('+ 5,00 gr'), findsOneWidget);
    expect(find.text('≈ ₺29.211,50'), findsOneWidget);
    expect(find.text('+ ₺125.000,00'), findsOneWidget);
  });

  testWidgets('empty database shows the onboarding state', (tester) async {
    await pumpApp(tester, const []);
    await tester.pumpAndSettle();

    expect(find.text('Finansal yolculuğunu başlat'), findsOneWidget);
    expect(find.text('İlk İşlemini Ekle'), findsOneWidget);
  });

  testWidgets('the entry form offers all types, currencies and a refresh', (
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
    expect(find.text('USD'), findsWidgets);
    expect(find.text('EUR'), findsWidgets);
    expect(find.text('XAU'), findsWidgets);
    expect(find.text('Güncelle'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);

    // The timestamp belongs to the rate data, not to "now".
    expect(find.text('Son güncelleme: 09:30'), findsOneWidget);
  });

  testWidgets('rebuilding the rate card never moves the timestamp', (
    tester,
  ) async {
    await pumpApp(tester, const []);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Son güncelleme: 09:30'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Son güncelleme: 09:30'), findsOneWidget);
  });

  testWidgets('movements screen exposes period, type and donut analytics', (
    tester,
  ) async {
    await pumpApp(tester, [
      tx(
        type: TransactionType.expense,
        amount: 3500,
        categoryId: 112,
        subcategoryId: 11200,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      tx(
        type: TransactionType.expense,
        amount: 1500,
        categoryId: 113,
        subcategoryId: 11300,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hareketler').last);
    await tester.pumpAndSettle();

    expect(find.text('1 AY'), findsOneWidget);
    expect(find.text('3 AY'), findsOneWidget);
    expect(find.text('6 AY'), findsOneWidget);
    expect(find.text('TÜMÜ'), findsOneWidget);
    expect(find.text('Kategori Dağılımı'), findsOneWidget);
    expect(find.text('Araç'), findsWidgets);
    expect(find.text('Market & Gıda'), findsWidgets);
  });
}
