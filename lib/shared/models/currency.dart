/// Display currencies. A transaction stores its own currency plus the rate
/// snapshot taken when it was saved, so historical values never move.
enum Currency {
  tryLira(label: 'TL', code: 'TRY', symbol: '₺', symbolIsPrefix: true),
  usd(label: 'USD', code: 'USD', symbol: r'$', symbolIsPrefix: true),
  eur(label: 'EUR', code: 'EUR', symbol: '€', symbolIsPrefix: true),
  xau(label: 'XAU', code: 'XAU', symbol: ' gr', symbolIsPrefix: false);

  const Currency({
    required this.label,
    required this.code,
    required this.symbol,
    required this.symbolIsPrefix,
  });

  /// Short label used by the dashboard filter (`TL`).
  final String label;

  /// ISO-style code used by the entry form (`TRY`).
  final String code;

  final String symbol;
  final bool symbolIsPrefix;

  bool get isTry => this == Currency.tryLira;

  /// Gold is entered and displayed in grams.
  bool get isGold => this == Currency.xau;
}
