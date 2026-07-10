import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import '../../../core/widgets/custom_charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Dashboard Overview Title + Date Picker Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard Overview',
                  style: AppTextStyle.body16Medium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.textSecondary),
                      SizedBox(width: 6),
                      Text(
                        '20 May 2024',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.35,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildKPICard('Total Reports', '1,248', '↑ 12.5%', Icons.insert_drive_file_outlined, Colors.blue, Colors.green),
                _buildKPICard('Pending Reports', '312', '↑ 8.2%', Icons.access_time, Colors.orange, Colors.green),
                _buildKPICard('Returned Reports', '68', '↓ 3.1%', Icons.assignment_return_outlined, Colors.pink, Colors.red),
                _buildKPICard('Approved Reports', '716', '↑ 10.4%', Icons.check_circle_outline_rounded, Colors.green, Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Middle Charts Section (Donut Chart & Line Chart)
            Text('Report Metrics', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Reports by Type', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 140,
                    child: CustomPieChart(
                      values: [40, 30, 20, 10],
                      colors: [AppColors.primaryBlue, AppColors.emerald, AppColors.yellow, AppColors.purple],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLegendRow('Lashing & Measurement', '40%', Colors.blue),
                  _buildLegendRow('ODC Survey', '30%', Colors.green),
                  _buildLegendRow('Container Damage', '20%', Colors.amber),
                  _buildLegendRow('Others', '10%', Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reports Trend', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Text('7 Days', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    height: 150,
                    child: CustomLineChart(
                      data: [75, 110, 95, 145, 125, 230, 180, 220],
                      labels: ['14 May', '15 May', '16 May', '17 May', '18 May', '19 May', '20 May'],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Section: Recent Reports + Quick Actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Reports', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                          Text('View All', style: TextStyle(fontSize: 11, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildRecentReportItem('MSR-2024-1250', 'Lashing & Measurement Survey • Oceanic Star', 'Approved', Colors.green, '20 May 2024'),
                      _buildRecentReportItem('MSR-2024-1249', 'ODC Survey • Maersk Dubai', 'Pending', Colors.orange, '20 May 2024'),
                      _buildRecentReportItem('MSR-2024-1248', 'Container Damage Survey • MSC Glory', 'Under Review', Colors.blue, '19 May 2024'),
                      _buildRecentReportItem('MSR-2024-1247', 'Lashing & Measurement • Evergreen', 'Returned', Colors.red, '19 May 2024'),
                      _buildRecentReportItem('MSR-2024-1246', 'ODC Survey • HMM Rotterdam', 'In Progress', Colors.purple, '18 May 2024'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Actions', style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildQuickActionRow('Create New Report', Icons.add, Colors.blue),
                _buildQuickActionRow('Assign Survey By', Icons.person_add_alt_1_rounded, Colors.green),
                _buildQuickActionRow('Assign Checked By', Icons.verified_user_rounded, Colors.purple),
                _buildQuickActionRow('Upload Documents', Icons.cloud_upload_outlined, Colors.orange),
                _buildQuickActionRow('View Audit Logs', Icons.history_edu_rounded, Colors.blue),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, String stat, IconData icon, Color iconColor, Color statColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              Text(
                stat,
                style: TextStyle(
                  fontSize: 11,
                  color: statColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String label, String percent, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
          Text(percent, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildRecentReportItem(String id, String subtitle, String status, Color statusColor, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_outlined, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 8, color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionRow(String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}
