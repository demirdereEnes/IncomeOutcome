import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/transaction_type.dart';
import '../domain/category.dart';
import '../domain/category_catalog.dart';

final categoriesProvider = Provider<List<Category>>((ref) => categoryCatalog);

/// Categories offered by the entry form: current catalog only, no legacy.
final selectableCategoriesProvider =
    Provider.family<List<Category>, TransactionType>((ref, type) {
      final categories =
          ref
              .watch(categoriesProvider)
              .where((c) => c.type == type && !c.isLegacy)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return categories;
    });

final categoryLookupProvider = Provider<Map<int, Category>>(
  (ref) => categoriesById,
);

final subcategoryLookupProvider = Provider<Map<int, Subcategory>>(
  (ref) => subcategoriesById,
);
