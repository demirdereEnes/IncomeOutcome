import 'package:flutter/material.dart';

import '../features/transactions/presentation/new_transaction_screen.dart';
import 'home_shell.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String newTransaction = '/transactions/new';
}

abstract final class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeShell(),
        );
      case AppRoutes.newTransaction:
        return MaterialPageRoute<void>(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => const NewTransactionScreen(),
        );
      default:
        return null;
    }
  }
}
