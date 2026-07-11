import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'surveyor_data_store.dart';

class SurveyorPhotoGalleryScreen extends StatelessWidget {
  const SurveyorPhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = SurveyorDataStore.instance;
    final List<Map<String, dynamic>> allPhotos = [];
    for (var r in ds.reports) {
      final list = r['photos'] as List<dynamic>? ?? [];
      for (var p in list) {
        allPhotos.add({
          'reportId': r['id'],
          'category': p['category'],
          'caption': p['caption'],
          'metadata': p['metadata'],
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: allPhotos.isEmpty
          ? const Center(child: Text('No uploaded photos in active surveys.', style: TextStyle(color: AppColors.textSecondary)))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: allPhotos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final photo = allPhotos[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.image_outlined, size: 36, color: AppColors.primaryBlue),
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
                                  child: Text(photo['category'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(photo['caption'] ?? '', style: AppTextStyle.body11Medium.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
                            Text('Report: ${photo['reportId']}', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
