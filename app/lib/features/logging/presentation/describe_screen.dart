import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../application/logging_providers.dart';
import 'widgets/parsed_items_review.dart';

class DescribeScreen extends ConsumerStatefulWidget {
  const DescribeScreen({super.key});

  @override
  ConsumerState<DescribeScreen> createState() => _DescribeScreenState();
}

class _DescribeScreenState extends ConsumerState<DescribeScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _parse() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await ref
          .read(geminiFoodServiceProvider)
          .parseDescription(_controller.text.trim());
      if (!mounted) return;
      final logged = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Review items')),
            body: ParsedItemsReview(
              items: items,
              method: LogMethod.naturalLanguage,
            ),
          ),
        ),
      );
      if (logged == true && mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(geminiFoodServiceProvider).isConfigured;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Describe')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Describe what you ate — multiple items, exclusions, and '
              'restaurant meals all work.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'e.g. "Chipotle bowl, chicken, brown rice, no beans, '
                    'guac, a large latte"',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (!configured)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'No Gemini API key is configured in this build, so '
                  'natural-language logging can\'t run yet. Set '
                  'GEMINI_API_KEY to enable it.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed:
                  configured && !_loading && _controller.text.trim().isNotEmpty
                  ? _parse
                  : null,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Parse'),
            ),
          ],
        ),
      ),
    );
  }
}
