import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'connection/connection.dart';

/// Native platforms only (iOS/Android/desktop) — the primary targets per
/// Checkpoint 1. On web this throws when first queried (see
/// connection/web_connection.dart). Overridden with an in-memory database
/// in tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openConnection());
  ref.onDispose(db.close);
  return db;
});
