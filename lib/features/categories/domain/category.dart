import '../../../shared/models/transaction_type.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconKey,
    required this.sortOrder,
    this.isDefault = true,
  });

  final int id;
  final String name;
  final TransactionType type;

  /// Stable key resolved to an [IconData] by `categoryIcon`.
  final String iconKey;
  final int sortOrder;
  final bool isDefault;
}
