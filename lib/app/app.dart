import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/transactions/application/transactions_providers.dart';
import '../features/transactions/data/development_seed.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// One-off startup work. Kept here rather than in `main()` so it shares the
/// same provider container - and therefore the same database - as the app.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  if (!kDebugMode) return;
  try {
    await seedDevelopmentDataIfEmpty(ref.read(transactionRepositoryProvider));
  } catch (_) {
    // A failed development seed must never block startup.
  }
});

class IncomeOutcomeApp extends ConsumerWidget {
  const IncomeOutcomeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appBootstrapProvider);

    return MaterialApp(
      title: 'Finansal Durum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('tr', 'TR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr', 'TR')],
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
