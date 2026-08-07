import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/units/units.dart';
import '../../../core/units/units_providers.dart';
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
  final _heightFeetController = TextEditingController();
  final _heightInchesController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _continue(UnitSystem unitSystem) {
    if (_sex == null || !_formKey.currentState!.validate()) {
      setState(() {}); // surface the "select sex" hint if that's what's missing
      return;
    }

    final heightCm = unitSystem == UnitSystem.imperial
        ? inchesToCm(
            feetAndInchesToInches(
              int.parse(_heightFeetController.text),
              int.tryParse(_heightInchesController.text) ?? 0,
            ),
          )
        : double.parse(_heightController.text);
    final weightKg = unitSystem == UnitSystem.imperial
        ? lbToKg(double.parse(_weightController.text))
        : double.parse(_weightController.text);

    ref
        .read(onboardingControllerProvider.notifier)
        .setBodyStats(
          sex: _sex!,
          ageYears: int.parse(_ageController.text),
          heightCm: heightCm,
          weightKg: weightKg,
        );
    context.go(AppRoutes.activity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitSystem = ref.watch(unitSystemProvider).value ?? UnitSystem.metric;
    final isImperial = unitSystem == UnitSystem.imperial;

    return OnboardingScaffold(
      step: 2,
      totalSteps: 5,
      title: 'Tell us about your body',
      subtitle: 'Used only to calculate your starting calorie estimate.',
      primaryActionLabel: 'Continue',
      onPrimaryAction: () => _continue(unitSystem),
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
            if (isImperial)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightFeetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Height (ft)',
                      ),
                      validator: (value) {
                        final feet = int.tryParse(value ?? '');
                        if (feet == null || feet < 3 || feet > 8) {
                          return 'Enter feet (3-8)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _heightInchesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Height (in)',
                      ),
                      validator: (value) {
                        final inches = int.tryParse(value ?? '');
                        if (inches != null && (inches < 0 || inches > 11)) {
                          return '0-11';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            else
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
              decoration: InputDecoration(
                labelText: isImperial ? 'Weight (lb)' : 'Weight (kg)',
              ),
              validator: (value) {
                final weight = double.tryParse(value ?? '');
                final min = isImperial ? 66 : 30;
                final max = isImperial ? 660 : 300;
                if (weight == null || weight < min || weight > max) {
                  return 'Enter a weight between $min and $max ${isImperial ? 'lb' : 'kg'}';
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
