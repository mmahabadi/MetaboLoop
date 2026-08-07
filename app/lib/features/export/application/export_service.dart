import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import '../../../core/database/app_database.dart';
import '../domain/csv_export_builder.dart';

/// Exports the full logging + weight history as a CSV and hands it to the
/// platform share sheet. Builds the file in memory via [XFile.fromData]
/// rather than writing to disk, so this works on web too without touching
/// dart:io.
class ExportService {
  ExportService(this._db);

  final AppDatabase _db;

  Future<void> exportDailyHistoryCsv() async {
    final logEntries = await _db.getAllLogEntries();
    final weightEntries = await _db.getWeightEntriesBetween(
      DateTime(2000),
      DateTime.now().add(const Duration(days: 1)),
    );

    final csv = buildDailyCsv(
      logEntries: logEntries,
      weightEntries: weightEntries,
    );
    final bytes = Uint8List.fromList(utf8.encode(csv));

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'text/csv',
            name: 'metaboloop_export.csv',
          ),
        ],
        subject: 'MetaboLoop data export',
      ),
    );
  }
}
