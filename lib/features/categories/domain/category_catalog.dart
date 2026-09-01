import 'package:flutter/material.dart';

import '../../../shared/models/transaction_type.dart';
import 'category.dart';

/// Category ids are stable and never reused: rows in the database point at
/// them forever. Ids 1-21 belong to the Sprint 1/2 catalog and are kept as
/// legacy entries so existing transactions keep their original label.
abstract final class CategoryIds {
  // Income
  static const int salary = 100;
  static const int bonus = 101;
  static const int extraIncome = 102;
  static const int investmentIncome = 103;
  static const int otherIncome = 104;

  // Expense
  static const int home = 110;
  static const int bills = 111;
  static const int vehicle = 112;
  static const int groceries = 113;
  static const int family = 114;
  static const int subscriptions = 115;
  static const int shopping = 116;
  static const int entertainment = 117;
  static const int debtAndFinance = 118;

  // Saving / assets
  static const int gold = 130;
  static const int usd = 131;
  static const int eur = 132;
  static const int cash = 133;
  static const int fund = 134;
  static const int stocks = 135;
  static const int otherSaving = 136;
}

/// Subcategories that represent a debt movement rather than consumption.
const Set<int> debtSubcategoryIds = {11800, 11801, 11802, 11803, 11804};

List<Subcategory> _subs(int categoryId, List<String> names) => [
  for (var i = 0; i < names.length; i++)
    Subcategory(
      id: categoryId * 100 + i,
      categoryId: categoryId,
      name: names[i],
      sortOrder: i + 1,
    ),
];

final List<Category> _incomeCategories = [
  Category(
    id: CategoryIds.salary,
    name: 'Maaş',
    type: TransactionType.income,
    iconKey: 'salary',
    sortOrder: 1,
  ),
  Category(
    id: CategoryIds.bonus,
    name: 'Prim',
    type: TransactionType.income,
    iconKey: 'bonus',
    sortOrder: 2,
  ),
  Category(
    id: CategoryIds.extraIncome,
    name: 'Ek Gelir',
    type: TransactionType.income,
    iconKey: 'extra_income',
    sortOrder: 3,
  ),
  Category(
    id: CategoryIds.investmentIncome,
    name: 'Yatırım Geliri',
    type: TransactionType.income,
    iconKey: 'investment',
    sortOrder: 4,
  ),
  Category(
    id: CategoryIds.otherIncome,
    name: 'Diğer',
    type: TransactionType.income,
    iconKey: 'other',
    sortOrder: 5,
  ),
];

final List<Category> _expenseCategories = [
  Category(
    id: CategoryIds.home,
    name: 'Ev & Yaşam',
    type: TransactionType.expense,
    iconKey: 'home',
    sortOrder: 1,
    subcategories: _subs(CategoryIds.home, [
      'Kira',
      'Aidat',
      'Ev İhtiyaçları',
      'Bakım / Onarım',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.bills,
    name: 'Faturalar',
    type: TransactionType.expense,
    iconKey: 'bill',
    sortOrder: 2,
    subcategories: _subs(CategoryIds.bills, [
      'Elektrik',
      'Su',
      'Doğalgaz',
      'İnternet',
      'Telefon',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.vehicle,
    name: 'Araç',
    type: TransactionType.expense,
    iconKey: 'car',
    sortOrder: 3,
    subcategories: _subs(CategoryIds.vehicle, [
      'Akaryakıt',
      'Bakım',
      'Onarım',
      'Kasko',
      'Trafik Sigortası',
      'MTV',
      'HGS',
      'Otopark',
      'Yıkama',
      'Lastik',
      'Modifiye',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.groceries,
    name: 'Market & Gıda',
    type: TransactionType.expense,
    iconKey: 'groceries',
    sortOrder: 4,
    subcategories: _subs(CategoryIds.groceries, [
      'Market',
      'Restoran',
      'Yemek',
      'Kahve',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.family,
    name: 'Aile & Çocuk',
    type: TransactionType.expense,
    iconKey: 'kids',
    sortOrder: 5,
    subcategories: _subs(CategoryIds.family, [
      'Okul',
      'Giyim',
      'Oyuncak',
      'İhtiyaç',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.subscriptions,
    name: 'Abonelikler',
    type: TransactionType.expense,
    iconKey: 'subscription',
    sortOrder: 6,
    subcategories: _subs(CategoryIds.subscriptions, [
      'Netflix',
      'Spotify',
      'YouTube',
      'ChatGPT',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.shopping,
    name: 'Alışveriş',
    type: TransactionType.expense,
    iconKey: 'shopping',
    sortOrder: 7,
    subcategories: _subs(CategoryIds.shopping, [
      'Giyim',
      'Elektronik',
      'Ev',
      'Kişisel',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.entertainment,
    name: 'Eğlence',
    type: TransactionType.expense,
    iconKey: 'entertainment',
    sortOrder: 8,
    subcategories: _subs(CategoryIds.entertainment, [
      'Oyun',
      'Sinema',
      'Hobi',
      'Tatil',
      'Diğer',
    ]),
  ),
  Category(
    id: CategoryIds.debtAndFinance,
    name: 'Borç & Finans',
    type: TransactionType.expense,
    iconKey: 'debt',
    sortOrder: 9,
    subcategories: _subs(CategoryIds.debtAndFinance, [
      'Kredi Kartı Ödemesi',
      'Kredi Ödemesi',
      'Altın Borcu',
      'Döviz Borcu',
      'Kişisel Borç',
      'Banka Ücreti',
      'Diğer',
    ]),
  ),
];

final List<Category> _savingCategories = [
  Category(
    id: CategoryIds.gold,
    name: 'Altın',
    type: TransactionType.saving,
    iconKey: 'gold',
    sortOrder: 1,
  ),
  Category(
    id: CategoryIds.usd,
    name: 'Dolar',
    type: TransactionType.saving,
    iconKey: 'usd',
    sortOrder: 2,
  ),
  Category(
    id: CategoryIds.eur,
    name: 'Euro',
    type: TransactionType.saving,
    iconKey: 'eur',
    sortOrder: 3,
  ),
  Category(
    id: CategoryIds.cash,
    name: 'Nakit',
    type: TransactionType.saving,
    iconKey: 'cash',
    sortOrder: 4,
  ),
  Category(
    id: CategoryIds.fund,
    name: 'Yatırım Fonu',
    type: TransactionType.saving,
    iconKey: 'fund',
    sortOrder: 5,
  ),
  Category(
    id: CategoryIds.stocks,
    name: 'Hisse',
    type: TransactionType.saving,
    iconKey: 'stocks',
    sortOrder: 6,
  ),
  Category(
    id: CategoryIds.otherSaving,
    name: 'Diğer',
    type: TransactionType.saving,
    iconKey: 'other',
    sortOrder: 7,
  ),
];

/// Sprint 1/2 catalog. Never offered in the entry form again, but kept so
/// transactions created before Sprint 3 still render their original name.
const List<Category> _legacyCategories = [
  Category(id: 1, name: 'Maaş', type: TransactionType.income, iconKey: 'salary', sortOrder: 1, isLegacy: true),
  Category(id: 2, name: 'Freelance', type: TransactionType.income, iconKey: 'freelance', sortOrder: 2, isLegacy: true),
  Category(id: 3, name: 'Prim', type: TransactionType.income, iconKey: 'bonus', sortOrder: 3, isLegacy: true),
  Category(id: 4, name: 'Yatırım', type: TransactionType.income, iconKey: 'investment', sortOrder: 4, isLegacy: true),
  Category(id: 5, name: 'Kira Geliri', type: TransactionType.income, iconKey: 'rent_income', sortOrder: 5, isLegacy: true),
  Category(id: 6, name: 'Diğer', type: TransactionType.income, iconKey: 'other', sortOrder: 6, isLegacy: true),
  Category(id: 7, name: 'Market', type: TransactionType.expense, iconKey: 'groceries', sortOrder: 1, isLegacy: true),
  Category(id: 8, name: 'Fatura', type: TransactionType.expense, iconKey: 'bill', sortOrder: 2, isLegacy: true),
  Category(id: 9, name: 'Ulaşım', type: TransactionType.expense, iconKey: 'transport', sortOrder: 3, isLegacy: true),
  Category(id: 10, name: 'Yemek', type: TransactionType.expense, iconKey: 'food', sortOrder: 4, isLegacy: true),
  Category(id: 11, name: 'Sağlık', type: TransactionType.expense, iconKey: 'health', sortOrder: 5, isLegacy: true),
  Category(id: 12, name: 'Çocuk', type: TransactionType.expense, iconKey: 'kids', sortOrder: 6, isLegacy: true),
  Category(id: 13, name: 'Eğlence', type: TransactionType.expense, iconKey: 'entertainment', sortOrder: 7, isLegacy: true),
  Category(id: 14, name: 'Alışveriş', type: TransactionType.expense, iconKey: 'shopping', sortOrder: 8, isLegacy: true),
  Category(id: 15, name: 'Diğer', type: TransactionType.expense, iconKey: 'other', sortOrder: 9, isLegacy: true),
  Category(id: 16, name: 'Altın', type: TransactionType.saving, iconKey: 'gold', sortOrder: 1, isLegacy: true),
  Category(id: 17, name: 'Döviz', type: TransactionType.saving, iconKey: 'fx', sortOrder: 2, isLegacy: true),
  Category(id: 18, name: 'Mevduat', type: TransactionType.saving, iconKey: 'deposit', sortOrder: 3, isLegacy: true),
  Category(id: 19, name: 'Fon / Hisse', type: TransactionType.saving, iconKey: 'stocks', sortOrder: 4, isLegacy: true),
  Category(id: 20, name: 'Nakit', type: TransactionType.saving, iconKey: 'cash', sortOrder: 5, isLegacy: true),
  Category(id: 21, name: 'Diğer', type: TransactionType.saving, iconKey: 'other', sortOrder: 6, isLegacy: true),
];

/// Everything the app knows about, legacy included.
final List<Category> categoryCatalog = [
  ..._incomeCategories,
  ..._expenseCategories,
  ..._savingCategories,
  ..._legacyCategories,
];

final Map<int, Category> categoriesById = {
  for (final category in categoryCatalog) category.id: category,
};

final Map<int, Subcategory> subcategoriesById = {
  for (final category in categoryCatalog)
    for (final subcategory in category.subcategories) subcategory.id: subcategory,
};

const Map<String, IconData> _categoryIcons = {
  'salary': Icons.account_balance_wallet_outlined,
  'bonus': Icons.star_outline_rounded,
  'extra_income': Icons.add_card_outlined,
  'investment': Icons.trending_up_rounded,
  'freelance': Icons.laptop_mac_outlined,
  'rent_income': Icons.vpn_key_outlined,
  'home': Icons.home_outlined,
  'bill': Icons.receipt_long_outlined,
  'car': Icons.directions_car_outlined,
  'groceries': Icons.shopping_cart_outlined,
  'kids': Icons.child_care_outlined,
  'subscription': Icons.subscriptions_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'entertainment': Icons.movie_outlined,
  'debt': Icons.credit_card_outlined,
  'transport': Icons.directions_bus_outlined,
  'food': Icons.restaurant_outlined,
  'health': Icons.medical_services_outlined,
  'gold': Icons.workspace_premium_outlined,
  'usd': Icons.attach_money_rounded,
  'eur': Icons.euro_rounded,
  'fx': Icons.currency_exchange_rounded,
  'deposit': Icons.account_balance_outlined,
  'fund': Icons.pie_chart_outline_rounded,
  'stocks': Icons.show_chart_rounded,
  'cash': Icons.payments_outlined,
  'other': Icons.more_horiz_rounded,
};

IconData categoryIcon(String iconKey) =>
    _categoryIcons[iconKey] ?? Icons.more_horiz_rounded;
