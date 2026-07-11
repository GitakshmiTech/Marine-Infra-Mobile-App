import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'qc_data_store.dart';

class QCPhotoVerificationGalleryScreen extends StatefulWidget {
  const QCPhotoVerificationGalleryScreen({super.key});

  @override
  State<QCPhotoVerificationGalleryScreen> createState() => _QCPhotoVerificationGalleryScreenState();
}

class _QCPhotoVerificationGalleryScreenState extends State<QCPhotoVerificationGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final ds = QCDataStore.instance;
    final List<Map<String, dynamic>> allPhotos = [];
    for (var r in ds.reports) {
      final list = r['photos'] as List<dynamic>? ?? [];
      for (var p in list) {
        allPhotos.add({
          'reportId': r['id'],
          'category': p['category'],
          'caption': p['caption'],
          'metadata': p['metadata'],
          'photoRef': p,
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: allPhotos.isEmpty
          ? const Center(child: Text('No uploaded photos awaiting verification.', style: TextStyle(color: AppColors.textSecondary)))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: allPhotos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final photo = allPhotos[index];
                final pRef = photo['photoRef'] as Map<String, dynamic>;
                final isApproved = pRef['isVerified'] == true;
                final isRejected = pRef['isRejected'] == true;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isApproved
                          ? Colors.green
                          : isRejected
                              ? Colors.red
                              : AppColors.border,
                    ),
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
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          pRef['isVerified'] = true;
                                          pRef['isRejected'] = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: isApproved ? Colors.green : Colors.white,
                                        child: Icon(Icons.check, color: isApproved ? Colors.white : Colors.green, size: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          pRef['isVerified'] = false;
                                          pRef['isRejected'] = true;
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: isRejected ? Colors.red : Colors.white,
                                        child: Icon(Icons.close, color: isRejected ? Colors.white : Colors.red, size: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
