/// Web has no local file storage wired up yet — mirrors
/// core/database/connection/web_connection.dart's approach. Progress
/// photos are a native-platform feature for now; see app/README.md.
Future<String> copyToPhotosDir(String sourcePath, String fileName) {
  throw UnimplementedError(
    'Progress photo storage is not available on web yet. '
    'The app targets iOS/Android first — see app/README.md.',
  );
}

Future<void> deletePhotoFile(String path) async {}
