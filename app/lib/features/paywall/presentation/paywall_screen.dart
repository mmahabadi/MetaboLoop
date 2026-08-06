import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../domain/subscription_tier.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  SubscriptionTier _selected = SubscriptionTier.annual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start your free trial',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '7 days free, then your plan renews automatically. Cancel '
                'anytime before the trial ends and you won\'t be charged.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ...SubscriptionTier.values.map((tier) {
                final selected = _selected == tier;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: selected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(() => _selected = tier),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        tier.label,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      if (tier.badge != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            tier.badge!,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    tier.priceLabel,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_circle,
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              if (!AppConfig.isRevenueCatConfigured) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'No RevenueCat app is configured in this build, so '
                    'prices above are placeholders and purchases are '
                    'disabled. Set REVENUECAT_API_KEY to connect one.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Start free trial'),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Not now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
