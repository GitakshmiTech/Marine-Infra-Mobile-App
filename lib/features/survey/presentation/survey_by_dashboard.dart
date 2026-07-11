import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import 'surveyor_data_store.dart';

class SurveyByDashboardScreen extends StatefulWidget {
  final Function(int tabIndex, {String? reportId}) onViewReports;
  const SurveyByDashboardScreen({super.key, required this.onViewReports});

  @override
  State<SurveyByDashboardScreen> createState() => _SurveyByDashboardScreenState();
}

class _SurveyByDashboardScreenState extends State<SurveyByDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ds = SurveyorDataStore.instance;
    final totalAssigned = ds.reports.length;
    final newAssignments = ds.reports.where((r) => r['status'] == 'Assigned').length;
    final accepted = ds.reports.where((r) => r['status'] == 'Accepted').length;
    final inProgress = ds.reports.where((r) => r['status'] == 'In Progress').length;
    final returned = ds.reports.where((r) => r['status'] == 'Returned').length;
    final completed = ds.reports.where((r) => r['status'] == 'Completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            // Summary Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.45,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildCard('Total Assignments', '$totalAssigned', Icons.assignment, Colors.blue, () => widget.onViewReports(0)),
                _buildCard('New Assignments', '$newAssignments', Icons.assignment_late_outlined, Colors.purple, () => widget.onViewReports(1)),
                _buildCard('Accepted Reports', '$accepted', Icons.check_circle_outline, Colors.teal, () => widget.onViewReports(2)),
                _buildCard('In Progress', '$inProgress', Icons.directions_run_rounded, Colors.amber, () => widget.onViewReports(3)),
                _buildCard('Returned Reports', '$returned', Icons.assignment_return_outlined, Colors.red, () => widget.onViewReports(4)),
                _buildCard('Completed Reports', '$completed', Icons.task_alt_rounded, Colors.green, () => widget.onViewReports(5)),
              ],
            ),
            const SizedBox(height: 20),

            // Today's Work Section
            Text('Today\'s Work', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTodayRow('New Assignments Today', '$newAssignments', Icons.notification_important_outlined, Colors.purple),
                  const Divider(height: 16),
                  _buildTodayRow('Pending Field Surveys', '${accepted + inProgress + returned}', Icons.hourglass_empty_rounded, Colors.orange),
                  const Divider(height: 16),
                  _buildTodayRow('Due Today', '${newAssignments > 0 ? 1 : 0}', Icons.today, Colors.red),
                  const Divider(height: 16),
                  _buildTodayRow('Overdue Surveys', '0', Icons.alarm_off, Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Text('Quick Actions', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.assignment_turned_in,
                    label: 'New Assignments',
                    color: AppColors.purple,
                    onTap: () => widget.onViewReports(1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.run_circle_outlined,
                    label: 'Continue Survey',
                    color: AppColors.orange,
                    onTap: () => widget.onViewReports(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Activities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Activities', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
                const Icon(Icons.history, color: AppColors.textSecondary, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(4, ds.reports.length),
                itemBuilder: (context, index) {
                  final report = ds.reports[index];
                  IconData actIcon = Icons.add_alert_rounded;
                  Color actColor = Colors.blue;

                  if (report['status'] == 'Assigned') {
                    actIcon = Icons.assignment_late_outlined;
                    actColor = Colors.purple;
                  } else if (report['status'] == 'Accepted') {
                    actIcon = Icons.check_circle_outline_rounded;
                    actColor = Colors.teal;
                  } else if (report['status'] == 'Returned') {
                    actIcon = Icons.assignment_return_outlined;
                    actColor = Colors.red;
                  } else if (report['status'] == 'Completed') {
                    actIcon = Icons.task_alt;
                    actColor = Colors.green;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: actColor.withValues(alpha: 0.1),
                          child: Icon(actIcon, size: 16, color: actColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${report['type']} - ${report['id']}',
                                style: AppTextStyle.body13Semibold.copyWith(color: AppColors.textPrimary),
                              ),
                              Text(
                                'Status updated to: ${report['status']} | Vessel: ${report['vessel']}',
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          report['date'],
                          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
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
                Text(
                  count,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTodayRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyle.body13Medium.copyWith(color: AppColors.textPrimary)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyle.body13Semibold.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
