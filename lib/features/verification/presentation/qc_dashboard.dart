import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'qc_data_store.dart';

class QCDashboardScreen extends StatefulWidget {
  final Function(int tabIndex, {String? reportId}) onViewReports;
  const QCDashboardScreen({super.key, required this.onViewReports});

  @override
  State<QCDashboardScreen> createState() => _QCDashboardScreenState();
}

class _QCDashboardScreenState extends State<QCDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ds = QCDataStore.instance;
    final pending = ds.reports.where((r) => r['status'] == 'Pending Verification').length;
    final underReview = ds.reports.where((r) => r['status'] == 'Under Review').length;
    final returned = ds.reports.where((r) => r['status'] == 'Returned').length;
    final submitted = ds.reports.where((r) => r['status'] == 'Submitted').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            // Summary cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildCard('Pending QC', '$pending', Icons.pending_actions_outlined, Colors.purple, () => widget.onViewReports(1)),
                _buildCard('Under Review', '$underReview', Icons.rate_review_outlined, Colors.teal, () => widget.onViewReports(2)),
                _buildCard('Returned', '$returned', Icons.assignment_return_outlined, Colors.red, () => widget.onViewReports(3)),
                _buildCard('Submitted to Admin', '$submitted', Icons.send_to_mobile_rounded, Colors.green, () => widget.onViewReports(5)),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Text('Quick Actions', style: AppTextStyle.body14Semibold),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    label: 'Verify New Report',
                    icon: Icons.checklist_rtl_rounded,
                    color: AppColors.primaryBlue,
                    onTap: () => widget.onViewReports(1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionButton(
                    label: 'View Returned',
                    icon: Icons.assignment_return,
                    color: Colors.red,
                    onTap: () => widget.onViewReports(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Charts Section
            Text('QC Statistics & Metrics', style: AppTextStyle.body14Semibold),
            const SizedBox(height: 10),
            _buildChartCard(),
            const SizedBox(height: 20),

            // Recent Activities
            Text('Recent Verification Activity', style: AppTextStyle.body14Semibold),
            const SizedBox(height: 10),
            _buildActivitiesList(ds),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withValues(alpha: 0.1),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textMuted),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(count, style: AppTextStyle.h2.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(label, style: AppTextStyle.body12Medium.copyWith(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daily Verification Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Target: 95%', style: TextStyle(color: AppColors.primaryBlue, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Custom premium chart layout using containers
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('Mon', 0.6),
                  _buildBar('Tue', 0.8),
                  _buildBar('Wed', 0.4),
                  _buildBar('Thu', 0.95),
                  _buildBar('Fri', 0.75),
                  _buildBar('Sat', 0.9),
                  _buildBar('Sun', 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, double ratio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: max(10, 80 * ratio),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.cyan],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildActivitiesList(QCDataStore ds) {
    // List some activities across reports
    final List<Map<String, dynamic>> list = [];
    for (var r in ds.reports) {
      final act = r['activities'] as List<dynamic>? ?? [];
      for (var a in act) {
        list.add({
          'reportId': r['id'],
          'title': a['title'],
          'desc': a['desc'],
          'time': a['time'],
        });
      }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: min(3, list.length),
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final act = list[index];
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: AppColors.background,
              child: const Icon(Icons.history_toggle_off_rounded, size: 16, color: AppColors.textSecondary),
            ),
            title: Text('${act['reportId']} - ${act['title']}', style: AppTextStyle.body12Medium.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text(act['desc'] ?? '', style: const TextStyle(fontSize: 9)),
            trailing: Text(act['time'] ?? '', style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
          );
        },
      ),
    );
  }
}
