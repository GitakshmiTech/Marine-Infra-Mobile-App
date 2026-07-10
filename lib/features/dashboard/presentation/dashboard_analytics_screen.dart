import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_style.dart';
import '../../../core/widgets/custom_charts.dart';

class DashboardAnalyticsScreen extends StatelessWidget {
  const DashboardAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turnaround Metrics', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Average Times Cards
            Row(
              children: [
                Expanded(child: _buildMetricCard('Avg Survey Time', '4.2 hrs', Icons.timer, AppColors.emeraldCyanGradient)),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricCard('Avg Approval Time', '1.8 days', Icons.speed, AppColors.purplePinkGradient)),
              ],
            ),
            const SizedBox(height: 20),

            // Survey Status (Pie)
            Text('Status Distribution', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 160,
                      child: CustomPieChart(
                        values: [70, 20, 10],
                        colors: [AppColors.emerald, AppColors.orange, AppColors.pink],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _LegendItem(color: AppColors.emerald, label: 'Approved (70%)'),
                        _LegendItem(color: AppColors.orange, label: 'Pending (20%)'),
                        _LegendItem(color: AppColors.pink, label: 'Returned (10%)'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Trend (Bar)
            Text('Monthly Survey Trends', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: const CustomBarChart(
                data: [42, 58, 65, 80, 95, 110, 130],
                labels: ['Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Leaderboard
            Text('Surveyor Leaderboard', style: AppTextStyle.body16Medium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPerformanceRow('Sarah Connor', '48 surveys completed', '4.8 rating', AppColors.emerald),
                    const Divider(),
                    _buildPerformanceRow('David Lightman', '35 surveys completed', '4.6 rating', AppColors.primaryBlue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, List<Color> gradient) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyle.body12Regular, overflow: TextOverflow.ellipsis),
                  Text(value, style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String name, String surveys, String rating, Color scoreColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: scoreColor.withOpacity(0.1),
            child: Text(name[0], style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyle.body14Medium.copyWith(fontWeight: FontWeight.bold)),
                Text(surveys, style: AppTextStyle.body12Regular),
              ],
            ),
          ),
          Text(rating, style: AppTextStyle.body14Medium.copyWith(color: AppColors.yellow, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
