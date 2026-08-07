import 'package:drift/drift.dart';

/// Web has no native SQLite database wired up yet — drift's web support
/// requires a separate WASM setup (a bundled sqlite3.wasm, worker
/// registration, OPFS/IndexedDB storage) that isn't done in this pass.
/// This stub exists only so `dart:io`/`dart:ffi`-based native code never
/// gets pulled into the web compilation target — see
/// `openNativeConnection` in native_connection.dart, which is what
/// actually runs on the primary target platforms (iOS/Android). The error
/// is deferred (via [LazyDatabase]) until a query is actually attempted,
/// so the rest of the app can still run on web.
LazyDatabase openConnection() {
  return LazyDatabase(() {
    throw UnimplementedError(
      'MetaboLoop has no local database configured for web yet. '
      'The app targets iOS/Android first — see app/README.md.',
    );
  });
}
