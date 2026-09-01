/// Marks a transaction as a debt movement instead of ordinary spending.
///
/// Debt movements are deliberately excluded from Total Expense: the original
/// purchase was already recorded as an expense, so counting the repayment
/// again would double count it.
enum DebtOperation {
  add(label: 'Borç Ekle'),
  pay(label: 'Borç Öde');

  const DebtOperation({required this.label});

  final String label;
}
