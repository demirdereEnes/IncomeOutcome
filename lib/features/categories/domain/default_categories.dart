import 'package:flutter/material.dart';

import '../../../shared/models/transaction_type.dart';
import 'category.dart';

/// The default catalog shipped with the app. Sprint 2 seeds these rows into
/// SQLite; until then they are the single source of truth.
const List<Category> defaultCategories = [
  // Income
  Category(id: 1, name: 'Maaş', type: TransactionType.income, iconKey: 'salary', sortOrder: 1),
  Category(id: 2, name: 'Freelance', type: TransactionType.income, iconKey: 'freelance', sortOrder: 2),
  Category(id: 3, name: 'Prim', type: TransactionType.income, iconKey: 'bonus', sortOrder: 3),
  Category(id: 4, name: 'Yatırım', type: TransactionType.income, iconKey: 'investment', sortOrder: 4),
  Category(id: 5, name: 'Kira Geliri', type: TransactionType.income, iconKey: 'rent_income', sortOrder: 5),
  Category(id: 6, name: 'Diğer', type: TransactionType.income, iconKey: 'other', sortOrder: 6),

  // Expense
  Category(id: 7, name: 'Market', type: TransactionType.expense, iconKey: 'groceries', sortOrder: 1),
  Category(id: 8, name: 'Fatura', type: TransactionType.expense, iconKey: 'bill', sortOrder: 2),
  Category(id: 9, name: 'Ulaşım', type: TransactionType.expense, iconKey: 'transport', sortOrder: 3),
  Category(id: 10, name: 'Yemek', type: TransactionType.expense, iconKey: 'food', sortOrder: 4),
  Category(id: 11, name: 'Sağlık', type: TransactionType.expense, iconKey: 'health', sortOrder: 5),
  Category(id: 12, name: 'Çocuk', type: TransactionType.expense, iconKey: 'kids', sortOrder: 6),
  Category(id: 13, name: 'Eğlence', type: TransactionType.expense, iconKey: 'entertainment', sortOrder: 7),
  Category(id: 14, name: 'Alışveriş', type: TransactionType.expense, iconKey: 'shopping', sortOrder: 8),
  Category(id: 15, name: 'Diğer', type: TransactionType.expense, iconKey: 'other', sortOrder: 9),

  // Saving
  Category(id: 16, name: 'Altın', type: TransactionType.saving, iconKey: 'gold', sortOrder: 1),
  Category(id: 17, name: 'Döviz', type: TransactionType.saving, iconKey: 'fx', sortOrder: 2),
  Category(id: 18, name: 'Mevduat', type: TransactionType.saving, iconKey: 'deposit', sortOrder: 3),
  Category(id: 19, name: 'Fon / Hisse', type: TransactionType.saving, iconKey: 'stocks', sortOrder: 4),
  Category(id: 20, name: 'Nakit', type: TransactionType.saving, iconKey: 'cash', sortOrder: 5),
  Category(id: 21, name: 'Diğer', type: TransactionType.saving, iconKey: 'other', sortOrder: 6),
];

const Map<String, IconData> _categoryIcons = {
  'salary': Icons.account_balance_wallet_outlined,
  'freelance': Icons.laptop_mac_outlined,
  'bonus': Icons.star_outline_rounded,
  'investment': Icons.trending_up_rounded,
  'rent_income': Icons.vpn_key_outlined,
  'groceries': Icons.shopping_cart_outlined,
  'bill': Icons.receipt_long_outlined,
  'transport': Icons.directions_bus_outlined,
  'food': Icons.restaurant_outlined,
  'health': Icons.medical_services_outlined,
  'kids': Icons.child_care_outlined,
  'entertainment': Icons.movie_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'gold': Icons.workspace_premium_outlined,
  'fx': Icons.currency_exchange_rounded,
  'deposit': Icons.account_balance_outlined,
  'stocks': Icons.show_chart_rounded,
  'cash': Icons.payments_outlined,
  'other': Icons.more_horiz_rounded,
};

IconData categoryIcon(String iconKey) =>
    _categoryIcons[iconKey] ?? Icons.more_horiz_rounded;
