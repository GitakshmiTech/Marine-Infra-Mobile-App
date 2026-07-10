import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  String _activeCategoryFilter = 'All';

  final List<Map<String, dynamic>> _logs = [
    {
      'id': 'LOG-48192',
      'timestamp': '2026-07-10 14:15:32',
      'user': 'Alexander Marin',
      'role': 'Company Admin',
      'module': 'Authentication',
      'action': 'Login Success',
      'ip': '192.168.1.12',
      'device': 'Windows 11 PC',
      'browser': 'Chrome v124',
      'status': 'Success'
    },
    {
      'id': 'LOG-48190',
      'timestamp': '2026-07-10 12:02:10',
      'user': 'Sarah Connor',
      'role': 'Prepared By',
      'module': 'Reports',
      'action': 'Report Submitted',
      'ip': '192.168.2.44',
      'device': 'iPad Pro',
      'browser': 'Safari Mobile',
      'status': 'Success'
    },
    {
      'id': 'LOG-48174',
      'timestamp': '2026-07-09 09:30:15',
      'user': 'John Miller',
      'role': 'Checked By',
      'module': 'Users',
      'action': 'Password Reset',
      'ip': '192.168.1.5',
      'device': 'MacBook Pro',
      'browser': 'Firefox v120',
      'status': 'Success'
    },
    {
      'id': 'LOG-48162',
      'timestamp': '2026-07-08 17:44:02',
      'user': 'David Lightman',
      'role': 'Survey By',
      'module': 'Signature',
      'action': 'Signature Uploaded',
      'ip': '192.168.3.11',
      'device': 'iPhone 15 Pro',
      'browser': 'Survey App Client',
      'status': 'Success'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Authentication', 'Users', 'Reports', 'Signature'];

    final filteredLogs = _logs.where((log) {
      if (_activeCategoryFilter == 'All') return true;
      return log['module'] == _activeCategoryFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _activeCategoryFilter == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _activeCategoryFilter = category;
                      });
                    },
                    selectedColor: AppColors.primaryBlue.withOpacity(0.08),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryBlue : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
          ),

          // Audit feed
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text('No audit trail records', style: AppTextStyle.body14Regular),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(log['id'], style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                                Text(log['timestamp'], style: AppTextStyle.body12Regular.copyWith(color: AppColors.textMuted)),
                              ],
                            ),
                            const Divider(height: 20),
                            Text('User: ${log['user']} (${log['role']})', style: AppTextStyle.body14Regular),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text('Action: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    log['action'],
                                    style: AppTextStyle.body12Regular.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('IP: ${log['ip']} | Device: ${log['device']}', style: AppTextStyle.body12Regular.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
