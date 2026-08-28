/// Transaction kinds. Savings are tracked separately: "Birikim" is the sum of
/// saving entries, never `income - expense`.
enum TransactionType {
  income(label: 'Gelir', isNegative: false),
  expense(label: 'Gider', isNegative: true),
  saving(label: 'Birikim', isNegative: false);

  const TransactionType({required this.label, required this.isNegative});

  final String label;

  /// Whether list rows render the amount with a leading `-`.
  final bool isNegative;

  bool get isIncome => this == TransactionType.income;

  bool get isExpense => this == TransactionType.expense;

  bool get isSaving => this == TransactionType.saving;
}
