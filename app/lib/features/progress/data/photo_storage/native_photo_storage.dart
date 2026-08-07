import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies the file at [sourcePath] into the app's local
/// `progress_photos/` directory, returning the new file's path. Native
/// platforms only — see photo_storage.dart.
Future<String> copyToPhotosDir(String sourcePath, String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final photosDir = Directory(p.join(dir.path, 'progress_photos'));
  if (!await photosDir.exists()) {
    await photosDir.create(recursive: true);
  }
  final destPath = p.join(photosDir.path, fileName);
  await File(sourcePath).copy(destPath);
  return destPath;
}

Future<void> deletePhotoFile(String path) async {
  final file = File(path);
  if (await file.exists()) await file.delete();
}
