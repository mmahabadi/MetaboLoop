import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../application/onboarding_controller.dart';
import '../domain/body_stats.dart';
import 'widgets/onboarding_scaffold.dart';

class BodyStatsScreen extends ConsumerStatefulWidget {
  const BodyStatsScreen({super.key});

  @override
  ConsumerState<BodyStatsScreen> createState() => _BodyStatsScreenState();
}

class _BodyStatsScreenState extends ConsumerState<BodyStatsScreen> {
  final _formKey = GlobalKey<FormState>();
  Sex? _sex;
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_sex == null || !_formKey.currentState!.validate()) {
      setState(() {}); // surface the "select sex" hint if that's what's missing
      return;
    }

    ref
        .read(onboardingControllerProvider.notifier)
        .setBodyStats(
          sex: _sex!,
          ageYears: int.parse(_ageController.text),
          heightCm: double.parse(_heightController.text),
          weightKg: double.parse(_weightController.text),
        );
    context.go(AppRoutes.activity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OnboardingScaffold(
      step: 2,
      totalSteps: 5,
      title: 'Tell us about your body',
      subtitle:
          'Used only to calculate your starting calorie estimate. '
          'Metric units for now — imperial support is coming later.',
      primaryActionLabel: 'Continue',
      onPrimaryAction: _continue,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sex', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<Sex>(
              segments: const [
                ButtonSegment(value: Sex.female, label: Text('Female')),
                ButtonSegment(value: Sex.male, label: Text('Male')),
              ],
              selected: {?_sex},
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) {
                setState(
                  () => _sex = selection.isEmpty ? null : selection.first,
                );
              },
            ),
            if (_sex == null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Select one to continue',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Age (years)'),
              validator: (value) {
                final age = int.tryParse(value ?? '');
                if (age == null || age < 13 || age > 100) {
                  return 'Enter an age between 13 and 100';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              validator: (value) {
                final height = double.tryParse(value ?? '');
                if (height == null || height < 100 || height > 250) {
                  return 'Enter a height between 100 and 250 cm';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              validator: (value) {
                final weight = double.tryParse(value ?? '');
                if (weight == null || weight < 30 || weight > 300) {
                  return 'Enter a weight between 30 and 300 kg';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
