enum SubscriptionTier {
  monthly(
    label: 'Monthly',
    priceLabel: '\$9.99/mo',
    productId: 'metaboloop_monthly',
  ),
  sixMonth(
    label: '6 Months',
    priceLabel: '\$44.99 (\$7.50/mo)',
    productId: 'metaboloop_6month',
    badge: 'Save 25%',
  ),
  annual(
    label: 'Annual',
    priceLabel: '\$69.99 (\$5.83/mo)',
    productId: 'metaboloop_annual',
    badge: 'Best value',
  );

  const SubscriptionTier({
    required this.label,
    required this.priceLabel,
    required this.productId,
    this.badge,
  });

  final String label;

  /// Placeholder pricing shown until a real RevenueCat offering is wired
  /// up — actual prices are set in App Store Connect / Play Console and
  /// fetched from RevenueCat at runtime, not hardcoded here long-term.
  final String priceLabel;
  final String productId;
  final String? badge;
}
