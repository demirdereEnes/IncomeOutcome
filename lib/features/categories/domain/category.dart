import '../../../shared/models/transaction_type.dart';

class Subcategory {
  const Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.sortOrder,
  });

  final int id;
  final int categoryId;
  final String name;
  final int sortOrder;
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconKey,
    required this.sortOrder,
    this.subcategories = const [],
    this.isLegacy = false,
  });

  final int id;
  final String name;
  final TransactionType type;

  /// Stable key resolved to an [IconData] by `categoryIcon`.
  final String iconKey;
  final int sortOrder;
  final List<Subcategory> subcategories;

  /// Retired categories, kept only so historical rows keep their original
  /// label. They never appear in the entry form.
  final bool isLegacy;

  bool get hasSubcategories => subcategories.isNotEmpty;
}
