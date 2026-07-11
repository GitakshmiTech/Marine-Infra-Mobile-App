import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'qc_data_store.dart';

class QCNotificationsScreen extends StatelessWidget {
  const QCNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = QCDataStore.instance.notifications;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: list.isEmpty
          ? const Center(child: Text('No notifications.', style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final notif = list[index];
                final isNew = notif['isNew'] == 'true';
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  color: isNew ? Colors.blue.shade50.withValues(alpha: 0.3) : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isNew ? AppColors.primaryBlue : Colors.grey.shade100,
                      child: Icon(Icons.notifications, color: isNew ? Colors.white : Colors.grey, size: 20),
                    ),
                    title: Text(notif['title'] ?? '', style: AppTextStyle.body13Semibold),
                    subtitle: Text(notif['desc'] ?? '', style: const TextStyle(fontSize: 10)),
                    trailing: Text(notif['time'] ?? '', style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
                  ),
                );
              },
            ),
    );
  }
}
