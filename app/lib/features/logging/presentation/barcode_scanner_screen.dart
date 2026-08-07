import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../application/logging_providers.dart';
import 'widgets/quantity_entry_sheet.dart';

/// Camera + OCR-fallback barcode scanning is required by the spec; OCR
/// fallback for damaged/unreadable barcodes needs the same vision backend
/// as Snap (not configured — see that screen). This screen covers the
/// camera-scan path. Untestable visually in this sandbox: no camera
/// hardware and headless Chromium has no camera permission flow — the
/// scan/lookup logic below is what to review, not a screenshot.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  bool _handling = false;
  String? _error;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;

    setState(() {
      _handling = true;
      _error = null;
    });

    final food = await ref.read(foodRepositoryProvider).lookupBarcode(code);
    if (!mounted) return;

    if (food == null) {
      setState(() {
        _handling = false;
        _error =
            "No product found for barcode $code. Try search or add it manually.";
      });
      return;
    }

    final logged = await showQuantityEntrySheet(context, food: food);
    if (!mounted) return;
    if (logged) {
      Navigator.of(context).pop();
    } else {
      setState(() => _handling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan barcode')),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          if (_error != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error!),
                ),
              ),
            ),
          if (_handling) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
