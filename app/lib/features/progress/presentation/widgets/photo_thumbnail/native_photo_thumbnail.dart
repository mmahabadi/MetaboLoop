import 'dart:io';

import 'package:flutter/material.dart';

Widget buildPhotoThumbnail(String filePath, {BoxFit fit = BoxFit.cover}) {
  return Image.file(File(filePath), fit: fit);
}
