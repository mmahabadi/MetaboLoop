import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import 'photo_storage/photo_storage.dart';

const _uuid = Uuid();

class ProgressRepository {
  ProgressRepository(this._db);

  final AppDatabase _db;

  Future<void> addPhoto({
    required DateTime date,
    required String sourcePath,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final id = _uuid.v4();
    final extension = sourcePath.contains('.')
        ? sourcePath.split('.').last
        : 'jpg';
    final savedPath = await copyToPhotosDir(sourcePath, '$id.$extension');
    await _db.insertProgressPhoto(
      ProgressPhotosCompanion.insert(id: id, date: day, filePath: savedPath),
    );
  }

  Future<void> deletePhoto(ProgressPhoto photo) async {
    await _db.deleteProgressPhoto(photo.id);
    await deletePhotoFile(photo.filePath);
  }

  Future<void> upsertMeasurement(BodyMeasurementsCompanion measurement) {
    return _db.upsertBodyMeasurement(measurement);
  }
}
