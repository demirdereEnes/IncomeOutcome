import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.watch(appDatabaseProvider)),
);

/// Live view of the database. Any insert or delete pushes a new list, which is
/// what keeps the dashboard, chart and movement list in sync.
final transactionsProvider = StreamProvider<List<Transaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchAll(),
);

/// Loaded transactions, or an empty list while the first read is in flight.
final transactionListProvider = Provider<List<Transaction>>(
  (ref) => ref.watch(transactionsProvider).value ?? const [],
);
