import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the on-device database file for native platforms (iOS/Android/
/// desktop) — the primary targets per Checkpoint 1. Web support requires
/// drift's separate WASM setup and is not wired up yet; see app/README.md.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'metaboloop.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
