import 'package:flutter/material.dart';

/// Web has no local file storage (see ../../data/photo_storage), so there
/// are never real photos to render here — this placeholder exists only to
/// keep dart:io out of the web compile target.
Widget buildPhotoThumbnail(String filePath, {BoxFit fit = BoxFit.cover}) {
  return const ColoredBox(
    color: Color(0xFFE4E4E7),
    child: Center(child: Icon(Icons.image_not_supported_outlined)),
  );
}
