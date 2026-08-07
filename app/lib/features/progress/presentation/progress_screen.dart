import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../application/progress_providers.dart';
import 'widgets/measurement_entry_sheet.dart';
import 'widgets/photo_comparison_view.dart';
import 'widgets/photo_thumbnail/photo_thumbnail.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  final _selectedForComparison = <ProgressPhoto>[];

  Future<void> _addPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: source);
    if (photo == null) return;
    await ref
        .read(progressRepositoryProvider)
        .addPhoto(date: DateTime.now(), sourcePath: photo.path);
  }

  Future<void> _showAddPhotoOptions() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _addPhoto(source);
  }

  void _togglePhotoSelection(ProgressPhoto photo) {
    setState(() {
      if (_selectedForComparison.contains(photo)) {
        _selectedForComparison.remove(photo);
      } else {
        if (_selectedForComparison.length == 2) {
          _selectedForComparison.removeAt(0);
        }
        _selectedForComparison.add(photo);
      }
    });

    if (_selectedForComparison.length == 2) {
      final sorted = [..._selectedForComparison]
        ..sort((a, b) => a.date.compareTo(b.date));
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) =>
                  PhotoComparisonView(before: sorted[0], after: sorted[1]),
            ),
          )
          .then((_) => setState(_selectedForComparison.clear));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Measurements'),
              Tab(text: 'Photos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MeasurementsTab(),
            _PhotosTab(
              selected: _selectedForComparison,
              onTapPhoto: _togglePhotoSelection,
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final isPhotosTab = DefaultTabController.of(context).index == 1;
            return FloatingActionButton(
              onPressed: isPhotosTab
                  ? _showAddPhotoOptions
                  : () => showMeasurementEntrySheet(context),
              child: Icon(isPhotosTab ? Icons.add_a_photo : Icons.add),
            );
          },
        ),
      ),
    );
  }
}

class _MeasurementsTab extends ConsumerWidget {
  const _MeasurementsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(bodyMeasurementsProvider);

    return measurementsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load measurements: $e')),
      data: (measurements) {
        if (measurements.isEmpty) {
          return const Center(child: Text('No measurements logged yet.'));
        }
        return ListView(
          children: [
            for (final m in measurements)
              ListTile(
                title: Text(DateFormat.yMMMd().format(m.date)),
                subtitle: Text(
                  [
                    if (m.waistCm != null) 'Waist ${m.waistCm}cm',
                    if (m.chestCm != null) 'Chest ${m.chestCm}cm',
                    if (m.hipsCm != null) 'Hips ${m.hipsCm}cm',
                    if (m.armCm != null) 'Arm ${m.armCm}cm',
                    if (m.thighCm != null) 'Thigh ${m.thighCm}cm',
                  ].join(' · '),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PhotosTab extends ConsumerWidget {
  const _PhotosTab({required this.selected, required this.onTapPhoto});

  final List<ProgressPhoto> selected;
  final void Function(ProgressPhoto) onTapPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(progressPhotosProvider);

    return photosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load photos: $e')),
      data: (photos) {
        if (photos.isEmpty) {
          return const Center(
            child: Text('No progress photos yet. Tap + to add one.'),
          );
        }
        return Column(
          children: [
            if (selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Tap a second photo to compare (${selected.length}/2 selected)',
                ),
              ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final isSelected = selected.contains(photo);
                  return GestureDetector(
                    onTap: () => onTapPhoto(photo),
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: buildPhotoThumbnail(photo.filePath),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
