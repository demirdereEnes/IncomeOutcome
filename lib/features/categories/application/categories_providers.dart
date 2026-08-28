import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/transaction_type.dart';
import '../domain/category.dart';
import '../domain/default_categories.dart';

final categoriesProvider = Provider<List<Category>>((ref) => defaultCategories);

final categoriesByTypeProvider = Provider.family<List<Category>, TransactionType>(
  (ref, type) => ref
      .watch(categoriesProvider)
      .where((category) => category.type == type)
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
);

/// Fast id -> category lookup for list rendering.
final categoryLookupProvider = Provider<Map<int, Category>>(
  (ref) => {for (final category in ref.watch(categoriesProvider)) category.id: category},
);
