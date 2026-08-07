import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import 'photo_thumbnail/photo_thumbnail.dart';

class PhotoComparisonView extends StatelessWidget {
  const PhotoComparisonView({
    super.key,
    required this.before,
    required this.after,
  });

  final ProgressPhoto before;
  final ProgressPhoto after;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare')),
      body: Row(
        children: [
          Expanded(child: _Side(photo: before)),
          const VerticalDivider(width: 1),
          Expanded(child: _Side(photo: after)),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.photo});

  final ProgressPhoto photo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(DateFormat.yMMMd().format(photo.date)),
        ),
        Expanded(
          child: buildPhotoThumbnail(photo.filePath, fit: BoxFit.contain),
        ),
      ],
    );
  }
}
